using Godot;

public partial class BeesNode : Node2D
{
    public override void _Ready()
    {
        GameManager.Instance.BeesNode = this;
    }
}
