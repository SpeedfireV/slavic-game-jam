using Godot;

[System.Serializable]
public partial class CollectableResources : Resource
{
    [Export] public int honeycomb = 0;
    [Export] public int beeswax = 0;
    [Export] public int nectar = 0;
    [Export] public int beepollen = 0;
    [Export] public int energy = 0;

    public CollectableResources()
    {
        // Default constructor
    }

    public CollectableResources(int honeycomb = 0, int beeswax = 0, int nectar = 0, int beepollen = 0, int energy = 0)
    {
        this.honeycomb = honeycomb;
        this.beeswax = beeswax;
        this.nectar = nectar;
        this.beepollen = beepollen;
        this.energy = energy;
    }
}
