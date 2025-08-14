using Godot;

public partial class BeeRowElement : PanelContainer
{
    private TextureRect bee_icon;
    private Bee bee;
    private StyleBoxFlat custom_theme;

    public override void _Ready()
    {
        bee_icon = GetNode<TextureRect>("%BeeIcon");
        custom_theme = (StyleBoxFlat)GetThemeStylebox("panel").Duplicate();
        AddThemeStyleboxOverride("panel", custom_theme);
        
        GD.Print(bee, GameManager.Instance.selected_bee);
        if (GameManager.Instance.selected_bee == bee && GameManager.Instance.selected_bee != null)
        {
            custom_theme.BorderColor = new Color(0xff0000ff);
        }
        else
        {
            custom_theme.BorderColor = new Color(0xffffffff);
        }
    }

    public void SetBee(Bee _bee)
    {
        bee = _bee;
        // Commented out bee type specific icon setting
        // if (bee.type == Bee.BeeType.NORMAL)
        // {
        //     bee_icon.Texture = GD.Load<Texture2D>("res://assets/hexagons/bees/normal_bee.png");
        // }
        // else if (bee.type == Bee.BeeType.WARRIOR)
        // {
        //     bee_icon.Texture = GD.Load<Texture2D>("res://assets/hexagons/bees/warrior_bee.png");
        // }
        // else if (bee.type == Bee.BeeType.COLLECTOR)
        // {
        //     bee_icon.Texture = GD.Load<Texture2D>("res://assets/hexagons/bees/collector_bee.png");
        // }
        // else if (bee.type == Bee.BeeType.SUPPORT)
        // {
        //     bee_icon.Texture = GD.Load<Texture2D>("res://assets/hexagons/bees/support_bee.png");
        // }
        // else if (bee.type == Bee.BeeType.QUEEN)
        // {
        //     bee_icon.Texture = GD.Load<Texture2D>("res://assets/hexagons/bees/queen_bee.png");
        // }
        // else
        // {
        //     GD.PrintErr("Unknown bee type: " + bee.type.ToString());
        // }
    }

    public override void _GuiInput(InputEvent @event)
    {
        if (@event is InputEventMouseButton mouseEvent && 
            mouseEvent.ButtonIndex == MouseButton.Left && 
            mouseEvent.Pressed)
        {
            if (bee != null)
            {
                GameManager.Instance.selected_bee = bee;
                GameManager.Instance.Navigator.ShowNavigation();
                GameManager.Instance.Hud.hex_description.Visible = true;
            }
        }
    }

    public override void _Process(double delta)
    {
        if (GameManager.Instance.selected_bee == bee && GameManager.Instance.selected_bee != null)
        {
            custom_theme.BorderColor = new Color(0xff0000ff);
        }
        else
        {
            custom_theme.BorderColor = new Color(0xffffffff);
        }
    }
}
