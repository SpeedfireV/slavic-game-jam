using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class MapHexagon : Node2D
{
    public enum HexagonType
    {
        Empty,
        Flower,
        Beehive,
        Blocade,
        Grass
    }

    public class Neighbours
    {
        public Dictionary<HexagonOrientation, MapHexagon> hexagons = new Dictionary<HexagonOrientation, MapHexagon>
        {
            { HexagonOrientation.Right, null },
            { HexagonOrientation.Left, null },
            { HexagonOrientation.TopLeft, null },
            { HexagonOrientation.TopRight, null },
            { HexagonOrientation.BottomLeft, null },
            { HexagonOrientation.BottomRight, null }
        };

        public MapHexagon left_hexagon = null;
        public MapHexagon right_hexagon = null;
        public MapHexagon top_left_hexagon = null;
        public MapHexagon top_right_hexagon = null;
        public MapHexagon bottom_left_hexagon = null;
        public MapHexagon bottom_right_hexagon = null;

        public bool AllFilled()
        {
            return left_hexagon != null && right_hexagon != null &&
                   top_left_hexagon != null && top_right_hexagon != null &&
                   bottom_left_hexagon != null && bottom_right_hexagon != null;
        }

        public List<HexagonOrientation> GetNotFilled()
        {
            var notFilled = new List<HexagonOrientation>();
            if (left_hexagon == null)
                notFilled.Add(HexagonOrientation.Left);
            if (right_hexagon == null)
                notFilled.Add(HexagonOrientation.Right);
            if (top_left_hexagon == null)
                notFilled.Add(HexagonOrientation.TopLeft);
            if (top_right_hexagon == null)
                notFilled.Add(HexagonOrientation.TopRight);
            if (bottom_left_hexagon == null)
                notFilled.Add(HexagonOrientation.BottomLeft);
            if (bottom_right_hexagon == null)
                notFilled.Add(HexagonOrientation.BottomRight);
            return notFilled;
        }

        public void SetNeighbouringHexagon(MapHexagon hexagon, HexagonOrientation orientation)
        {
            switch (orientation)
            {
                case HexagonOrientation.Left:
                    left_hexagon = hexagon;
                    break;
                case HexagonOrientation.Right:
                    right_hexagon = hexagon;
                    break;
                case HexagonOrientation.TopLeft:
                    top_left_hexagon = hexagon;
                    break;
                case HexagonOrientation.TopRight:
                    top_right_hexagon = hexagon;
                    break;
                case HexagonOrientation.BottomLeft:
                    bottom_left_hexagon = hexagon;
                    break;
                case HexagonOrientation.BottomRight:
                    bottom_right_hexagon = hexagon;
                    break;
            }
        }
    }

    private Sprite2D hexagon_sprite;
    private Sprite2D hexagon_border;
    private Sprite2D hexagon_resource;
    private Area2D interaction_area;
    private CpuParticles2D flower_particles;

    public Flower flower_resource;
    public Neighbours neighbours = new Neighbours();
    public Vector2I coords = Vector2I.Zero;
    public HexagonType hexagon_type = HexagonType.Empty;
    public bool selected = false;
    public List<Unit> units_on_hex = [];

    private bool _mouse_on_top = false;
    public bool mouse_on_top
    {
        get { return _mouse_on_top; }
        set
        {
            _mouse_on_top = value;
            if (!selected)
            {
                if (_mouse_on_top)
                {
                    var tween = CreateTween();
                    tween.TweenProperty(hexagon_border, "modulate", new Color(0xffff00ff), 0.1);
                }
                else
                {
                    var tween = CreateTween();
                    tween.TweenProperty(hexagon_border, "modulate", new Color(0xffffffff), 0.1);
                }
            }
        }
    }

    private readonly HexagonType[] possible_random_hexagon_types = {
        HexagonType.Empty,
        HexagonType.Flower,
        HexagonType.Blocade,
        HexagonType.Grass
    };

    private static readonly Texture2D[] OBSTACLES = {
        GD.Load<Texture2D>("res://assets/hexagons/obstacles/big_stone.png"),
        GD.Load<Texture2D>("res://assets/hexagons/obstacles/scary_bush.png"),
        GD.Load<Texture2D>("res://assets/hexagons/obstacles/lake.png"),
        GD.Load<Texture2D>("res://assets/hexagons/obstacles/trees.png")
    };

    private static readonly Texture2D DEFAULT_HEX_BORDER = GD.Load<Texture2D>("res://assets/hexagons/default_hex_border.png");
    private static readonly Texture2D ALERT_HEX_BORDER = GD.Load<Texture2D>("res://assets/hexagons/alert_hex_border.png");

    public override void _Ready()
    {
        hexagon_sprite = GetNode<Sprite2D>("%HexSprite");
        hexagon_border = GetNode<Sprite2D>("%HexBorder");
        hexagon_resource = GetNode<Sprite2D>("%HexResource");
        interaction_area = GetNode<Area2D>("%InteractionArea");
        flower_particles = GetNode<CpuParticles2D>("%FlowerParticles");

        if (coords == Vector2I.Zero)
        {
            hexagon_type = HexagonType.Beehive;
            var bee = Bees.NORMAL_BEE_SCENE.Instantiate<Bee>();
            bee.coords = coords;
            GameManager.Instance.AddNewUnit(bee);
        }
        else
        {
            hexagon_type = possible_random_hexagon_types[GD.RandRange(0, possible_random_hexagon_types.Length - 1)];
        }

        if (hexagon_type == HexagonType.Blocade)
        {
            hexagon_resource.Texture = OBSTACLES[GD.RandRange(0, OBSTACLES.Length - 1)];
            hexagon_resource.Scale = new Vector2(2, 2);
        }

        if (hexagon_type == HexagonType.Flower)
        {
            flower_resource = Flowers.FLOWER_TYPES[GD.RandRange(0, Flowers.FLOWER_TYPES.Length - 1)];
            if (flower_resource != null)
            {
                GD.Print(flower_resource.flower_name);
                hexagon_resource.Texture = flower_resource.flower_texture;
                hexagon_resource.Scale = new Vector2(1.7f, 1.7f);
                flower_particles.Emitting = true;
            }
            else
            {
                GD.PrintErr("MapHexagon: flower_resource is null!");
                hexagon_type = HexagonType.Empty; // Fallback to empty
            }
        }

        if (hexagon_type == HexagonType.Beehive)
        {
            hexagon_resource.Texture = GD.Load<Texture2D>("res://assets/hexagons/beehive/beehive.png");
        }

        interaction_area.MouseEntered += OnMouseEntered;
        interaction_area.MouseExited += OnMouseExited;
        GameManager.Instance.HexagonSelected += OnHexagonSelected;
    }

    public override void _UnhandledInput(InputEvent @event)
    {
        if (mouse_on_top && Input.IsActionJustPressed("select"))
        {
            OnHexagonClicked();
        }
    }

    public override void _Process(double delta)
    {
        if (GameManager.Instance.selected_hexagon == this)
        {
            // TODO: Implement VFX on selection
        }
    }

    private void OnMouseEntered()
    {
        mouse_on_top = true;
        GameManager.Instance.mouse_on_hex = this;
    }

    private void OnHexagonSelected(MapHexagon hexagon)
    {
        if (hexagon != this && selected)
        {
            selected = false;
            var tween = CreateTween();
            tween.TweenProperty(hexagon_border, "modulate", new Color(0xffffffff), 0.1);
        }
    }

    private void OnMouseExited()
    {
        mouse_on_top = false;
    }

    private void OnHexagonClicked()
    {
        GameManager.Instance.selected_hexagon = this;
        SelectionEffect();
    }

    public void SelectionEffect()
    {
        var tween = CreateTween();
        selected = true;
        tween.TweenProperty(hexagon_border, "modulate", new Color(0xff8100ff), 0.1);
    }

    public string GetHexResourceName()
    {
        return hexagon_type switch
        {
            HexagonType.Empty => "Empty",
            HexagonType.Flower => "Flower",
            HexagonType.Beehive => "Beehive",
            HexagonType.Blocade => "Blocade",
            HexagonType.Grass => "Grass",
            _ => "Unknown"
        };
    }

    public void Collect()
    {
        hexagon_type = HexagonType.Empty;
        flower_resource = null;
        hexagon_resource.Texture = null;
        GameManager.Instance.Hud.hex_description.UpdateInfo(GameManager.Instance.selected_hexagon);
    }
}
