using Godot;

public partial class Flower : HexagonResource
{
    [Export] public string flower_name;
    [Export] public Texture2D flower_texture;

    public Flower()
    {
        flower_name = "";
        flower_texture = null;
    }
}
