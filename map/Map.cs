using Godot;
using System;
using System.Collections.Generic;

public partial class Map : Node2D
{
    [Export] public int map_size = 50; // Number of rings
    [Export] public PackedScene map_hexagon_scene;

    // Track hexes by position
    public static Dictionary<Vector2I, MapHexagon> placed_hexagons = new Dictionary<Vector2I, MapHexagon>();

    public static Vector2 grid_step = new Vector2(60, 35); // Assuming hexagons are 64x64 pixels

    // Pixel-based direction offsets (pointy-topped hex grid)
    public static Dictionary<HexagonOrientation, Vector2I> orientation_to_pos = new Dictionary<HexagonOrientation, Vector2I>
    {
        { HexagonOrientation.Right, new Vector2I(2, 0) },
        { HexagonOrientation.Left, new Vector2I(-2, 0) },
        { HexagonOrientation.TopRight, new Vector2I(1, -3) },
        { HexagonOrientation.TopLeft, new Vector2I(-1, -3) },
        { HexagonOrientation.BottomRight, new Vector2I(1, 3) },
        { HexagonOrientation.BottomLeft, new Vector2I(-1, 3) }
    };

    private HexagonOrientation GetNextRotatedOrientation(HexagonOrientation orientation)
    {
        return orientation switch
        {
            HexagonOrientation.Right => HexagonOrientation.BottomRight,
            HexagonOrientation.BottomRight => HexagonOrientation.BottomLeft,
            HexagonOrientation.BottomLeft => HexagonOrientation.Left,
            HexagonOrientation.Left => HexagonOrientation.TopLeft,
            HexagonOrientation.TopLeft => HexagonOrientation.TopRight,
            HexagonOrientation.TopRight => HexagonOrientation.Right,
            _ => orientation // Fallback, should not happen
        };
    }

    private HexagonOrientation GetOppositeOrientation(HexagonOrientation orientation)
    {
        return orientation switch
        {
            HexagonOrientation.Right => HexagonOrientation.Left,
            HexagonOrientation.Left => HexagonOrientation.Right,
            HexagonOrientation.TopLeft => HexagonOrientation.BottomRight,
            HexagonOrientation.TopRight => HexagonOrientation.BottomLeft,
            HexagonOrientation.BottomLeft => HexagonOrientation.TopRight,
            HexagonOrientation.BottomRight => HexagonOrientation.TopLeft,
            _ => orientation // Fallback, should not happen
        };
    }

    public override void _Ready()
    {
        GenerateMap();
    }

    private void GenerateMap()
    {
        var lastPos = Vector2I.Zero;
        var currentRotation = HexagonOrientation.Right;
        AddHex(lastPos); // Add the center hexagon
        lastPos = new Vector2I(2, 0);
        currentRotation = HexagonOrientation.BottomLeft;
        
        for (int i = 1; i < map_size; i++)
        {
            for (int j = 0; j < i * 6; j++)
            {
                if (!placed_hexagons.ContainsKey(lastPos + orientation_to_pos[GetNextRotatedOrientation(currentRotation)]))
                {
                    currentRotation = GetNextRotatedOrientation(currentRotation);
                    lastPos += orientation_to_pos[currentRotation];
                }
                else
                {
                    lastPos += orientation_to_pos[currentRotation];
                }
                AddHex(lastPos);
            }
            lastPos += new Vector2I(1, 3);
            currentRotation = HexagonOrientation.BottomLeft;
        }
    }

    private void AddHex(Vector2I coords)
    {
        if (map_hexagon_scene == null)
        {
            GD.PrintErr("Map: map_hexagon_scene is null! Please assign the MapHexagon scene in the editor.");
            return;
        }
        
        var hex = map_hexagon_scene.Instantiate<MapHexagon>();
        if (hex == null)
        {
            GD.PrintErr("Map: Failed to instantiate MapHexagon from scene.");
            return;
        }
        
        placed_hexagons[coords] = hex;
        CheckForNeighbors(hex, coords);
        hex.Position = new Vector2(coords.X, coords.Y) * grid_step;
        hex.coords = coords;
        AddChild(hex);
    }

    private void CheckForNeighbors(MapHexagon hex, Vector2I pos)
    {
        foreach (HexagonOrientation orientation in Enum.GetValues<HexagonOrientation>())
        {
            var neighborPos = pos + orientation_to_pos[orientation];
            if (placed_hexagons.TryGetValue(neighborPos, out var neighborHex))
            {
                hex.neighbours.SetNeighbouringHexagon(neighborHex, orientation);
                neighborHex.neighbours.SetNeighbouringHexagon(hex, GetOppositeOrientation(orientation));
            }
        }
    }

    public static void MoveBee(Bee bee, Vector2I targetCoords)
    {
        placed_hexagons[bee.coords].units_on_hex.Remove(bee);
        var targetHex = placed_hexagons[targetCoords];
        bee.coords = targetCoords;
        targetHex.units_on_hex.Add(bee);
        GameManager.Instance.selected_hexagon = placed_hexagons.GetValueOrDefault(targetCoords);
    }
}
