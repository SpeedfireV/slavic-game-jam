using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class GameManager : Node
{
    public enum Season
    {
        Spring,
        Summer,
        Autumn,
        Winter
    }

    public static GameManager Instance { get; private set; }

    public CollectableResources CollectableResources = new CollectableResources();
    public Navigator Navigator;
    public BeesNode BeesNode;
    public BeesRow BeesRow;
    public Hud Hud;
    public Season CurrentSeason = Season.Spring;

    private MapHexagon _mouseOnHex;
    public MapHexagon mouse_on_hex
    {
        get => _mouseOnHex;
        set
        {
            _mouseOnHex = value;
            Navigator?.ShowNavigation();
        }
    }

    private Bee _selectedBee;
    public Bee selected_bee
    {
        get => _selectedBee;
        set
        {
            _selectedBee = value;
            Hud?.ShowHexDescription(selected_hexagon);
        }
    }

    private MapHexagon _selectedHexagon;
    public MapHexagon selected_hexagon
    {
        get => _selectedHexagon;
        set
        {
            Navigator?.ClearNavigation();
            var beesOnHex = new List<Bee>();
            if (value != null)
            {
                foreach (var unit in value.units_on_hex)
                {
                    if (unit is Bee bee)
                        beesOnHex.Add(bee);
                }
            }
            BeesRow?.SetBees(beesOnHex);
            
            if (value != null)
            {
                Hud?.ShowHexDescription(value);
            }
            else
            {
                if (Hud?.hex_description != null)
                    Hud.hex_description.Visible = false;
            }
            
            _selectedHexagon = value;
            
            if (_selectedHexagon != null)
            {
                if (!_selectedHexagon.units_on_hex.Contains(_selectedBee))
                    _selectedBee = null;
            }
            
            EmitSignal(SignalName.HexagonSelected, value);
        }
    }

    [Signal]
    public delegate void NextTurnSigEventHandler(Season currentSeason);

    [Signal]
    public delegate void HexagonSelectedEventHandler(MapHexagon hexagon);

    [Signal]
    public delegate void BeeSelectedEventHandler(Bee bee);

    public override void _Ready()
    {
        Instance = this;
    }

    public string GetSeasonName(Season season)
    {
        return season switch
        {
            Season.Spring => "Spring",
            Season.Summer => "Summer",
            Season.Autumn => "Autumn",
            Season.Winter => "Winter",
            _ => "Unknown Season"
        };
    }

    private Season NextSeasonEnum()
    {
        return CurrentSeason switch
        {
            Season.Spring => Season.Summer,
            Season.Summer => Season.Autumn,
            Season.Autumn => Season.Winter,
            Season.Winter => Season.Spring,
            _ => Season.Spring
        };
    }

    public void NextTurn()
    {
        CurrentSeason = NextSeasonEnum();
        EmitSignal(SignalName.NextTurnSig, (int)CurrentSeason);
        Hud?.AnimateToNextSeason();
    }

    public void AddNewUnit(Unit unit)
    {
        unit.GlobalPosition = new Vector2(unit.current_pos.X, unit.current_pos.Y) * Map.grid_step;
        BeesNode?.AddChild(unit);
        Map.placed_hexagons[unit.current_pos].units_on_hex.Add(unit);
    }

    // Static access methods for compatibility
    public static Navigator navigator_static => Instance.Navigator;
    public static MapHexagon mouse_on_hex_static
    {
        get => Instance.mouse_on_hex;
        set => Instance.mouse_on_hex = value;
    }
    public static Bee selected_bee_static
    {
        get => Instance.selected_bee;
        set => Instance.selected_bee = value;
    }
    public static MapHexagon selected_hexagon_static
    {
        get => Instance.selected_hexagon;
        set => Instance.selected_hexagon = value;
    }
    public static Hud hud_static => Instance.Hud;
}
