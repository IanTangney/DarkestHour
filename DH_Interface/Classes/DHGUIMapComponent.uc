//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DHGUIMapComponent extends GUIPanel;

const   SPAWN_POINTS_MAX =                  63; // Max spawn points total (make sure this matches GRI)
const   SPAWN_VEHICLES_MAX =                8;  // Max spawn vehicles total (make sure this matches GRI)
const   SQUAD_RALLY_POINTS_MAX =            16; // Max squad rally points (make sure this matches SRI)

var automated   DHGUICheckBoxButton         b_SpawnPoints[SPAWN_POINTS_MAX];

var             DHHud                       MyHud;
var             DHGameReplicationInfo       GRI;
var             DHPlayer                    PC;
var             DHPlayerReplicationInfo     PRI;

var             GUIContextMenu              SquadRallyPointContextMenu;
var             Material                    SpawnPointBlockedOverlay;

var             vector                      MapClickLocation;
var             array<class<DHMapMarker> >  MenuItemObjects;
var             int                         MapMarkerIndexToRemove;

var localized string        SquadRallyPointDestroyText;
var localized string        SquadRallyPointSetAsSecondaryText;
var localized string        RemoveText;

delegate OnSpawnPointChanged(int SpawnPointIndex, optional bool bDoubleClick);

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local int i;

    super.InitComponent(MyController, MyOwner);

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        b_SpawnPoints[i].Tag = i;
        b_SpawnPoints[i].ContextMenu.Tag = i;
        b_SpawnPoints[i].ContextMenu.OnOpen = MyContextOpen;
        b_SpawnPoints[i].ContextMenu.OnClose = MyContextClose;
        b_SpawnPoints[i].ContextMenu.OnSelect = MyContextSelect;
    }

    if (Controller != none)
    {
        // "Hide" the mouse cursor by sticking it in a corner.
        Controller.MouseX = 4096.0;
        Controller.MouseY = 4096.0;
    }

    PC = DHPlayer(PlayerOwner());

    if (PC != none)
    {
        PRI = DHPlayerReplicationInfo(PC.PlayerReplicationInfo);
        GRI = DHGameReplicationInfo(PC.GameReplicationInfo);
        MyHud = DHHud(PC.myHUD);
    }
}

function UpdateSpawnPoints(int TeamIndex, int RoleIndex, int VehiclePoolIndex, int SpawnPointIndex)
{
    local GUI.eFontScale FS;
    local float          X, Y;
    local int            SquadIndex, i;

    SquadIndex = -1;

    if (PRI != none)
    {
        SquadIndex = PRI.SquadIndex;
    }

    // Spawn points
    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        if (GRI != none &&
            GRI.SpawnPoints[i] != none &&
            GRI.SpawnPoints[i].IsVisibleTo(TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex))
        {
            GRI.GetMapCoords(GRI.SpawnPoints[i].Location, X, Y, b_SpawnPoints[i].WinWidth, b_SpawnPoints[i].WinHeight);

            b_SpawnPoints[i].SetPosition(X, Y, b_SpawnPoints[i].WinWidth, b_SpawnPoints[i].WinHeight, true);
            b_SpawnPoints[i].SetVisibility(true);
            b_SpawnPoints[i].CenterText = GRI.SpawnPoints[i].GetMapText();

            if (GRI.SpawnPoints[i].CanSpawnWithParameters(GRI, TeamIndex, RoleIndex, SquadIndex, VehiclePoolIndex, true))
            {
                b_SpawnPoints[i].MenuStateChange(MSAT_Blurry);
            }
            else
            {
                if (SpawnPointIndex != -1 && SpawnPointIndex == b_SpawnPoints[i].Tag)
                {
                    SelectSpawnPoint(-1);
                }

                b_SpawnPoints[i].MenuStateChange(MSAT_Disabled);
            }

            b_SpawnPoints[i].Style = Controller.GetStyle(GRI.SpawnPoints[i].GetMapStyleName(), FS);
        }
        else
        {
            // If spawn point that was previously selected is now hidden, deselect it.
            b_SpawnPoints[i].SetVisibility(false);

            if (SpawnPointIndex == b_SpawnPoints[i].Tag)
            {
                SelectSpawnPoint(-1);
            }
        }
    }
}

function bool InternalOnDraw(Canvas C)
{
    local ROHud.AbsoluteCoordsInfo SubCoords;

    if (bVisible)
    {
        SubCoords.PosX = ActualLeft();
        SubCoords.PosY = ActualTop();
        SubCoords.Width = ActualWidth();
        SubCoords.Height = ActualHeight();

        if (MyHud != none)
        {
            MyHud.DrawMap(C, SubCoords, PC);
        }
    }

    return false;
}

function SelectSpawnPoint(int SpawnPointIndex)
{
    local int i;

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        b_SpawnPoints[i].SetChecked(b_SpawnPoints[i].Tag != -1 && b_SpawnPoints[i].Tag == SpawnPointIndex);
    }

    OnSpawnPointChanged(SpawnPointIndex);
}

function InternalOnCheckChanged(GUIComponent Sender, bool bChecked)
{
    local int i;

    if (bChecked)
    {
        for (i = 0; i < arraycount(b_SpawnPoints); ++i)
        {
            if (Sender == b_SpawnPoints[i])
            {
                OnSpawnPointChanged(b_SpawnPoints[i].Tag);
            }
            else
            {
                b_SpawnPoints[i].SetChecked(false);
            }
        }
    }
}

function bool OnDblClick(GUIComponent Sender)
{
    local int i;

    for (i = 0; i < arraycount(b_SpawnPoints); ++i)
    {
        if (Sender == b_SpawnPoints[i])
        {
            OnSpawnPointChanged(b_SpawnPoints[i].Tag, true);

            return true;
        }
    }

    return false;
}

function bool MyContextOpen(GUIContextMenu Sender)
{
    local DHSpawnPoint_SquadRallyPoint SRP;
    local array<DHSpawnPoint_SquadRallyPoint> RallyPoints;

    if (Sender == none || PRI == none || GRI == none || PC == none || PC.SquadReplicationInfo == none || !PRI.IsSquadLeader())
    {
        return false;
    }

    SRP = DHSpawnPoint_SquadRallyPoint(GRI.SpawnPoints[Sender.Tag]);

    if (SRP == none || SRP.GetTeamIndex() != PC.GetTeamNum() || SRP.SquadIndex != PRI.SquadIndex || !SRP.IsActive())
    {
        return false;
    }

    Sender.ContextItems.Length = 0;
    Sender.AddItem(default.SquadRallyPointDestroyText);

    RallyPoints = PC.SquadReplicationInfo.GetActiveSquadRallyPoints(SRP.GetTeamIndex(), SRP.SquadIndex);

    if (RallyPoints.Length > 1)
    {
        Sender.AddItem("-");
        Sender.AddItem(default.SquadRallyPointSetAsSecondaryText);
    }

    return true;
}

function bool MyContextClose(GUIContextMenu Sender)
{
    return true;
}

function MyContextSelect(GUIContextMenu Sender, int Index)
{
    local DHSpawnPoint_SquadRallyPoint SRP;

    if (PRI == none || !PRI.IsSquadLeader())
    {
        return;
    }

    if (GRI != none)
    {
        SRP = DHSpawnPoint_SquadRallyPoint(GRI.SpawnPoints[Sender.Tag]);
    }

    switch (Index)
    {
        case 0:  // Destroy
            PC.ServerSquadDestroyRallyPoint(SRP);
            break;
        case 2:  // Set as secondary
            PC.ServerSquadSwapRallyPoints();
            break;
    }
}

function Material MyGetOverlayMaterial(GUIComponent Sender)
{
    local DHSpawnPointBase SP;

    if (Sender == none || GRI == none)
    {
        return none;
    }

    SP = GRI.SpawnPoints[Sender.Tag];

    if (SP != none && SP.IsBlocked())
    {
        return SpawnPointBlockedOverlay;
    }

    return none;
}

// Sort by linear insertion based on the group index!
function SortMapMarkerClasses(out array<class<DHMapMarker> > MapMarkerClasses)
{
    local int i, j;
    local class<DHMapMarker> Temp;

    for (i = 1; i < MapMarkerClasses.Length; ++i)
    {
        for (j = i; j > 0 && MapMarkerClasses[j - 1].default.GroupIndex > MapMarkerClasses[j].default.GroupIndex; j -= 1)
        {
            Temp = MapMarkerClasses[j - 1];
            MapMarkerClasses[j - 1] = MapMarkerClasses[j];
            MapMarkerClasses[j] = Temp;
        }
    }
}

function bool InternalOnOpen(GUIContextMenu Sender)
{
    local int i;
    local float L, T, W, H, D;
    local array<DHGameReplicationInfo.MapMarker> MapMarkers;
    local array<int> Indices;
    local array<class<DHMapMarker> > MapMarkerClasses;
    local int GroupIndex;
    local float X, Y;

    if (Sender == none || PC == none || PRI == none || GRI == none || !PRI.IsSquadLeader())
    {
        return false;
    }

    L = ActualLeft(WinLeft);
    T = ActualTop(WinTop);
    W = ActualWidth(WinWidth);
    H = ActualHeight(WinHeight);

    MapClickLocation.X = 1.0 - ((Controller.MouseX - L) / W);
    MapClickLocation.Y = 1.0 - ((Controller.MouseY - T) / H);

    Sender.ContextItems.Length = 0;

    // Iterate through existing map markers and check if any were clicked on.
    GRI.GetMapMarkers(MapMarkers, Indices, PC.GetTeamNum(), PC.GetSquadIndex());

    MenuItemObjects.Length = 0;
    MapMarkerIndexToRemove = -1;

    for (i = 0; i < MapMarkers.Length; ++i)
    {
        X = (float(MapMarkers[i].LocationX) / 255.0) - MapClickLocation.X;
        Y = (float(MapMarkers[i].LocationY) / 255.0) - MapClickLocation.Y;
        D = Sqrt(X * X + Y * Y);

        if (D <= class'DHHud'.default.MapMarkerIcon.TextureScale / 2.0)
        {
            // Clicked on an existing map marker, add the "remove" option.
            MapMarkerIndexToRemove = Indices[i];
            Sender.AddItem(RemoveText);
            MenuItemObjects[MenuItemObjects.Length] = none;
            break;
        }
    }

    // Fetch and sort map marker classes by group.
    for (i = 0; i < arraycount(GRI.MapMarkerClasses); ++i)
    {
        if (GRI.MapMarkerClasses[i] != none)
        {
            MapMarkerClasses[MapMarkerClasses.Length] = GRI.MapMarkerClasses[i];
        }
    }

    SortMapMarkerClasses(MapMarkerClasses);

    // Add separator if any other items already exist.
    if (Sender.ContextItems.Length > 0 && MapMarkerClasses.Length > 0)
    {
        Sender.AddItem("-");
        MenuItemObjects[MenuItemObjects.Length] = none;
    }

    GroupIndex = -1;

    // Add an option for each map marker.
    for (i = 0; i < MapMarkerClasses.Length; ++i)
    {
        if (GroupIndex != -1 && MapMarkerClasses[i].default.GroupIndex != GroupIndex)
        {
            // New group encountered, add a separator.
            Sender.AddItem("-");
            MenuItemObjects[MenuItemObjects.Length] = none;
        }

        Sender.AddItem(MapMarkerClasses[i].default.MarkerName);
        MenuItemObjects[MenuItemObjects.Length] = MapMarkerClasses[i];
        GroupIndex = MapMarkerClasses[i].default.GroupIndex;
    }

    return true;
}

function bool InternalOnClose(GUIContextMenu Sender)
{
    return true;
}

function InternalOnSelect(GUIContextMenu Sender, int ClickIndex)
{
    if (PC == none || ClickIndex < 0 || ClickIndex >= MenuItemObjects.Length)
    {
        return;
    }

    if (MenuItemObjects[ClickIndex] == none)
    {
        if (MapMarkerIndexToRemove != -1)
        {
            PC.ServerRemoveMapMarker(MapMarkerIndexToRemove);
        }
    }
    else
    {
        PC.ServerAddMapMarker(MenuItemObjects[ClickIndex], MapClickLocation.X, MapClickLocation.Y);
    }
}

defaultproperties
{
    SquadRallyPointDestroyText="Destroy"
    SquadRallyPointSetAsSecondaryText="Set as Secondary"
    RemoveText="Remove"

    SpawnPointBlockedOverlay=Texture'DH_GUI_tex.DeployMenu.spawn_point_disabled'

    OnDraw=InternalOnDraw

    Begin Object Class=GUIContextMenu Name=SRPContextMenu
        OnOpen=DHGUIMapComponent.MyContextOpen
        OnClose=DHGUIMapComponent.MyContextClose
        OnSelect=DHGUIMapComponent.MyContextSelect
    End Object

    // Spawn points
    Begin Object Class=DHGUICheckBoxButton Name=SpawnPointButton
        StyleName="DHSpawnButtonStyle"
        WinWidth=0.04
        WinHeight=0.04
        bTabStop=false
        OnClick=OnClick
        OnDblClick=OnDblClick
        bVisible=false
        CheckedOverlay(0)=Material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(1)=Material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(2)=Material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(3)=Material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        CheckedOverlay(4)=Material'DH_GUI_Tex.DeployMenu.spawn_point_osc'
        OnCheckChanged=InternalOnCheckChanged
        bCanClickUncheck=false
        ContextMenu=SRPContextMenu
        GetOverlayMaterial=MyGetOverlayMaterial
    End Object

    Begin Object Class=GUIContextMenu Name=MapMarkerMenu
        OnOpen=InternalOnOpen
        OnClose=InternalOnClose
        OnSelect=InternalOnSelect
    End Object
    ContextMenu=MapMarkerMenu

    //TODO: This is begging to be put into a loop somewhere
    b_SpawnPoints(0)=SpawnPointButton
    b_SpawnPoints(1)=SpawnPointButton
    b_SpawnPoints(2)=SpawnPointButton
    b_SpawnPoints(3)=SpawnPointButton
    b_SpawnPoints(4)=SpawnPointButton
    b_SpawnPoints(5)=SpawnPointButton
    b_SpawnPoints(6)=SpawnPointButton
    b_SpawnPoints(7)=SpawnPointButton
    b_SpawnPoints(8)=SpawnPointButton
    b_SpawnPoints(9)=SpawnPointButton
    b_SpawnPoints(10)=SpawnPointButton
    b_SpawnPoints(11)=SpawnPointButton
    b_SpawnPoints(12)=SpawnPointButton
    b_SpawnPoints(13)=SpawnPointButton
    b_SpawnPoints(14)=SpawnPointButton
    b_SpawnPoints(15)=SpawnPointButton
    b_SpawnPoints(16)=SpawnPointButton
    b_SpawnPoints(17)=SpawnPointButton
    b_SpawnPoints(18)=SpawnPointButton
    b_SpawnPoints(19)=SpawnPointButton
    b_SpawnPoints(20)=SpawnPointButton
    b_SpawnPoints(21)=SpawnPointButton
    b_SpawnPoints(22)=SpawnPointButton
    b_SpawnPoints(23)=SpawnPointButton
    b_SpawnPoints(24)=SpawnPointButton
    b_SpawnPoints(25)=SpawnPointButton
    b_SpawnPoints(26)=SpawnPointButton
    b_SpawnPoints(27)=SpawnPointButton
    b_SpawnPoints(28)=SpawnPointButton
    b_SpawnPoints(29)=SpawnPointButton
    b_SpawnPoints(30)=SpawnPointButton
    b_SpawnPoints(31)=SpawnPointButton
    b_SpawnPoints(32)=SpawnPointButton
    b_SpawnPoints(33)=SpawnPointButton
    b_SpawnPoints(34)=SpawnPointButton
    b_SpawnPoints(35)=SpawnPointButton
    b_SpawnPoints(36)=SpawnPointButton
    b_SpawnPoints(37)=SpawnPointButton
    b_SpawnPoints(38)=SpawnPointButton
    b_SpawnPoints(39)=SpawnPointButton
    b_SpawnPoints(40)=SpawnPointButton
    b_SpawnPoints(41)=SpawnPointButton
    b_SpawnPoints(42)=SpawnPointButton
    b_SpawnPoints(43)=SpawnPointButton
    b_SpawnPoints(44)=SpawnPointButton
    b_SpawnPoints(45)=SpawnPointButton
    b_SpawnPoints(46)=SpawnPointButton
    b_SpawnPoints(47)=SpawnPointButton
    b_SpawnPoints(48)=SpawnPointButton
    b_SpawnPoints(49)=SpawnPointButton
    b_SpawnPoints(50)=SpawnPointButton
    b_SpawnPoints(51)=SpawnPointButton
    b_SpawnPoints(52)=SpawnPointButton
    b_SpawnPoints(53)=SpawnPointButton
    b_SpawnPoints(54)=SpawnPointButton
    b_SpawnPoints(55)=SpawnPointButton
    b_SpawnPoints(56)=SpawnPointButton
    b_SpawnPoints(57)=SpawnPointButton
    b_SpawnPoints(58)=SpawnPointButton
    b_SpawnPoints(59)=SpawnPointButton
    b_SpawnPoints(60)=SpawnPointButton
    b_SpawnPoints(61)=SpawnPointButton
    b_SpawnPoints(62)=SpawnPointButton

    bAcceptsInput=true
}

