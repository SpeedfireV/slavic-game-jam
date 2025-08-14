using Godot;

public partial class Flowers : Node
{
    public static readonly Texture2D DANDELION_TEXTURE = GD.Load<Texture2D>("res://assets/flowers/dandelion.png");
    public static readonly Texture2D DAISY_TEXTURE = GD.Load<Texture2D>("res://assets/flowers/daisy.png");
    public static readonly Texture2D TULIP_TEXTURE = GD.Load<Texture2D>("res://assets/flowers/tulip.png");
    public static readonly Texture2D ROSE_TEXTURE = GD.Load<Texture2D>("res://assets/flowers/rose.png");
    public static readonly Texture2D SUNFLOWER_TEXTURE = GD.Load<Texture2D>("res://assets/flowers/sunflower.png");
    public static readonly Texture2D CLOVER_TEXTURE = GD.Load<Texture2D>("res://assets/flowers/clover.png");

    // Safely load flower resources with null checks
    public static readonly Flower CLOVER_FLOWER = LoadFlowerSafely("res://flowers/clover.tres");
    public static readonly Flower CORNFLOWER_FLOWER = LoadFlowerSafely("res://flowers/cornflower.tres");
    public static readonly Flower DAISY_FLOWER = LoadFlowerSafely("res://flowers/daisy.tres");
    public static readonly Flower DANDELION_FLOWER = LoadFlowerSafely("res://flowers/dandelion.tres");
    public static readonly Flower DANDELION_OLD_FLOWER = LoadFlowerSafely("res://flowers/dandelion_old.tres");
    public static readonly Flower FIELD_POPPY_FLOWER = LoadFlowerSafely("res://flowers/field_poppy.tres");
    public static readonly Flower LAVENDER_FLOWER = LoadFlowerSafely("res://flowers/lavender.tres");
    public static readonly Flower ROSE_FLOWER = LoadFlowerSafely("res://flowers/rose.tres");
    public static readonly Flower SUNFLOWER_FLOWER = LoadFlowerSafely("res://flowers/sunflower.tres");
    public static readonly Flower TULIP_FLOWER = LoadFlowerSafely("res://flowers/tulip.tres");
    public static readonly Flower VIOLET_FLOWER = LoadFlowerSafely("res://flowers/violet.tres");

    public static readonly Texture2D[] FLOWER_TEXTURES = {
        DANDELION_TEXTURE,
        DAISY_TEXTURE,
        TULIP_TEXTURE,
        ROSE_TEXTURE,
        SUNFLOWER_TEXTURE,
        CLOVER_TEXTURE
    };

    public static readonly Flower[] FLOWER_TYPES = {
        CLOVER_FLOWER,
        CORNFLOWER_FLOWER,
        DAISY_FLOWER,
        DANDELION_FLOWER,
        DANDELION_OLD_FLOWER,
        FIELD_POPPY_FLOWER,
        LAVENDER_FLOWER,
        ROSE_FLOWER,
        SUNFLOWER_FLOWER,
        TULIP_FLOWER,
        VIOLET_FLOWER
    };

    private static Flower LoadFlowerSafely(string path)
    {
        try
        {
            var resource = GD.Load<Flower>(path);
            if (resource != null)
            {
                return resource;
            }
        }
        catch (System.Exception e)
        {
            GD.PrintErr($"Failed to load flower resource at {path}: {e.Message}");
        }

        // Create a fallback flower if loading fails
        var fallback = new Flower();
        fallback.flower_name = "Unknown Flower";
        fallback.flower_texture = DAISY_TEXTURE; // Use daisy as default
        fallback.possible_resources = new CollectableResources(nectar: 1, beepollen: 1, energy: 1);
        return fallback;
    }
}
