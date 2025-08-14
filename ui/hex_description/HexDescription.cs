using Godot;

public partial class HexDescription : PanelContainer
{
    private Label resource_name_label;
    private Label coordinates_label;
    private Label nectar_label;
    private TextureRect nectar_icon;
    private Label beepollen_label;
    private TextureRect beepollen_icon;
    private Button collect_button;

    private bool show_info_resources = false;

    public override void _Ready()
    {
        resource_name_label = GetNode<Label>("%ResourceNameLabel");
        coordinates_label = GetNode<Label>("%Coords");
        nectar_label = GetNode<Label>("%NectarLabel");
        nectar_icon = GetNode<TextureRect>("%NectarIcon");
        beepollen_label = GetNode<Label>("%BeepollenLabel");
        beepollen_icon = GetNode<TextureRect>("%BeepollenIcon");
        collect_button = GetNode<Button>("%CollectButton");

        GameManager.Instance.HexagonSelected += UpdateInfo;
        collect_button.Pressed += OnCollectButtonPressed;
    }

    public void UpdateInfo(MapHexagon hexagon)
    {
        if (hexagon.hexagon_type == MapHexagon.HexagonType.Flower)
        {
            show_info_resources = true;
            resource_name_label.Text = hexagon.flower_resource.flower_name;
        }
        else
        {
            show_info_resources = false;
            resource_name_label.Text = hexagon.GetHexResourceName();
        }

        coordinates_label.Text = $"({hexagon.coords.X},{hexagon.coords.Y / 3})";
        
        if (!hexagon.units_on_hex.Contains(GameManager.Instance.selected_bee) || 
            GameManager.Instance.selected_bee == null || 
            hexagon.hexagon_type != MapHexagon.HexagonType.Flower)
        {
            collect_button.Visible = false;
        }
        else
        {
            collect_button.Visible = true;
            if (hexagon.flower_resource.possible_resources.energy > GameManager.Instance.selected_bee.moves_left)
            {
                collect_button.Disabled = true;
                collect_button.Text = "NOT ENOUGH MOVES";
            }
            else
            {
                collect_button.Disabled = false;
                GD.Print(hexagon);
                GD.Print(hexagon.flower_resource);
                GD.Print(hexagon.flower_resource.flower_name);
                GD.Print(hexagon.flower_resource.possible_resources);
                collect_button.Text = $"[{hexagon.flower_resource.possible_resources.energy} ENERGY] COLLECT";
            }
        }
    }

    public override void _Process(double delta)
    {
        if (!show_info_resources)
        {
            nectar_label.Visible = false;
            nectar_icon.Visible = false;
            beepollen_label.Visible = false;
            beepollen_icon.Visible = false;
        }
        else
        {
            if (GameManager.Instance.selected_hexagon?.flower_resource != null)
            {
                nectar_label.Text = GameManager.Instance.selected_hexagon.flower_resource.possible_resources.nectar.ToString();
                nectar_label.Visible = true;
                nectar_icon.Visible = true;
                beepollen_label.Text = GameManager.Instance.selected_hexagon.flower_resource.possible_resources.beepollen.ToString();
                beepollen_label.Visible = true;
                beepollen_icon.Visible = true;
            }
        }
    }

    private void OnCollectButtonPressed()
    {
        if (GameManager.Instance.selected_bee != null && 
            GameManager.Instance.selected_hexagon?.flower_resource != null &&
            GameManager.Instance.selected_bee.moves_left >= GameManager.Instance.selected_hexagon.flower_resource.possible_resources.energy)
        {
            GameManager.Instance.selected_bee.AddResources(GameManager.Instance.selected_hexagon.flower_resource.possible_resources);
            GameManager.Instance.selected_hexagon.Collect();
        }
    }
}
