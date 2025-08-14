using Godot;
using System;

public partial class Bee : Unit
{
    public enum BeeType
    {
        NORMAL,
        WARRIOR,
        COLLECTOR,
        SUPPORT,
        QUEEN
    }

    private static readonly string[] BEE_NAMES = {
        "Zbyszek",
        "Ania",
        "Krzysztof",
        "Magda",
        "Janek",
        "Basia",
        "Piotr",
        "Kasia",
        "Mahmud"
    };

    [Export] public int total_number_of_moves = 15;
    public int moves_left;
    public int health = 100;
    
    private Vector2I _coords;
    public Vector2I coords
    {
        get => _coords;
        set
        {
            _coords = value;
            GlobalPosition = new Vector2(value.X, value.Y) * Map.grid_step;
        }
    }

    public string bee_name;
    public BeeType type = BeeType.NORMAL;
    public CollectableResources equiped_resources = new CollectableResources();

    public override void _Ready()
    {
        moves_left = total_number_of_moves;
        bee_name = BEE_NAMES[GD.RandRange(0, BEE_NAMES.Length - 1)];
        // GameManager.next_turn_sig.connect(_on_next_turn)
    }

    public override void _Input(InputEvent @event)
    {
        if (GameManager.Instance.selected_bee == this)
        {
            if (Input.IsActionJustPressed("move"))
            {
                Navigator.MoveBee(this, GameManager.Instance.mouse_on_hex.coords);
            }
        }
    }

    public void AddResources(CollectableResources resources)
    {
        equiped_resources.beepollen += resources.beepollen;
        equiped_resources.honeycomb += resources.honeycomb;
        equiped_resources.beeswax += resources.beeswax;
        equiped_resources.nectar += resources.nectar;
        moves_left -= resources.energy;
    }

    public void GiveResourcesToHive()
    {
        GameManager.Instance.CollectableResources.beepollen += equiped_resources.beepollen;
        GameManager.Instance.CollectableResources.honeycomb += equiped_resources.honeycomb;
        GameManager.Instance.CollectableResources.beeswax += equiped_resources.beeswax;
        GameManager.Instance.CollectableResources.nectar += equiped_resources.nectar;
        equiped_resources = new CollectableResources();
    }

    // Commented out methods for future implementation
    // public void OnNextTurn(GameManager.Season nextSeason)
    // {
    //     moves_left = total_number_of_moves;
    //     if (nextSeason == GameManager.Season.Winter && 
    //         Map.placed_hexagons.GetValueOrDefault(coords)?.hexagon_type != MapHexagon.HexagonType.Beehive)
    //     {
    //         Die();
    //     }
    // }

    // public void Die()
    // {
    //     QueueFree();
    // }
}
