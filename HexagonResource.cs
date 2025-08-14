using Godot;

public partial class HexagonResource : Resource
{
    [Export] public CollectableResources possible_resources;

    public HexagonResource()
    {
        possible_resources = new CollectableResources();
    }
}
