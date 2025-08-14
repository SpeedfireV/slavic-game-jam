using Godot;
using System.Collections.Generic;

public partial class BeesRow : VBoxContainer
{
    private static readonly PackedScene BEE_ROW_ELEMENT_SCENE = GD.Load<PackedScene>("res://bee_row_element.tscn");

    private LineEdit bee_name;
    private HBoxContainer bees_row;
    private Label energy_left_label;

    public override void _Ready()
    {
        bee_name = GetNode<LineEdit>("%BeeName");
        bees_row = GetNode<HBoxContainer>("%BeesRow");
        energy_left_label = GetNode<Label>("%EnergyLeftName");

        GameManager.Instance.BeesRow = this;
        GameManager.Instance.BeeSelected += OnBeeSelected;
        bee_name.TextSubmitted += OnNewBeeNameSubmitted;
    }

    public void SetBees(List<Bee> bees)
    {
        foreach (Node child in bees_row.GetChildren())
        {
            if (child is BeeRowElement)
            {
                child.QueueFree(); // Clear existing elements
            }
        }

        foreach (var bee in bees)
        {
            var beeRowElement = BEE_ROW_ELEMENT_SCENE.Instantiate<BeeRowElement>();
            beeRowElement.SetBee(bee);
            bees_row.AddChild(beeRowElement);
        }
    }

    public override void _Process(double delta)
    {
        if (GameManager.Instance.selected_hexagon != null)
        {
            if (GameManager.Instance.selected_bee != null && 
                GameManager.Instance.selected_hexagon.units_on_hex.Contains(GameManager.Instance.selected_bee))
            {
                bee_name.Visible = true;
            }
            else
            {
                bee_name.Visible = false;
            }
        }

        if (GameManager.Instance.selected_bee != null)
        {
            energy_left_label.Visible = true;
            energy_left_label.Text = "Energy Left: " + GameManager.Instance.selected_bee.moves_left.ToString();
        }
        else
        {
            energy_left_label.Visible = false;
        }
    }

    private void OnBeeSelected(Bee bee)
    {
        bee_name.Text = bee.bee_name;
    }

    private void OnNewBeeNameSubmitted(string newName)
    {
        if (GameManager.Instance.selected_bee != null)
        {
            GameManager.Instance.selected_bee.bee_name = newName;
        }
    }
}
