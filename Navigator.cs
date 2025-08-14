using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class Navigator : Node2D
{
    private Line2D navigation_line;
    private Label navigation_cost_label;

    public bool reachable = false;
    public int move_cost = 0;

    // Hexagonal directions (assuming pointy-top hexagons with y/3 scaling)
    private static readonly Vector2I[] HEX_DIRECTIONS = {
        new Vector2I(1, 0),    // right
        new Vector2I(-1, 0),   // left
        new Vector2I(0, -3),   // top left (y/3 scaling)
        new Vector2I(1, -3),   // top right
        new Vector2I(-1, 3),   // bottom left
        new Vector2I(0, 3)     // bottom right
    };

    public override void _Ready()
    {
        navigation_line = GetNode<Line2D>("%NavigationLine");
        navigation_cost_label = GetNode<Label>("%NavigationCost");
        GameManager.Instance.Navigator = this;
    }

    public void ClearNavigation()
    {
        navigation_line.ClearPoints();
        navigation_cost_label.Text = "";
    }

    public void ShowNavigation()
    {
        navigation_line.ClearPoints();
        navigation_cost_label.Text = "";
        
        if (GameManager.Instance.selected_bee == null)
            return; // No bee selected, nothing to navigate

        if (GameManager.Instance.mouse_on_hex != null && GameManager.Instance.selected_hexagon != null)
        {
            var start = GameManager.Instance.selected_hexagon.coords;
            var goal = GameManager.Instance.mouse_on_hex.coords;

            var goalHex = Map.placed_hexagons.GetValueOrDefault(goal);
            if (goalHex == null || goalHex.hexagon_type == MapHexagon.HexagonType.Blocade)
            {
                navigation_line.ClearPoints();
                navigation_cost_label.Text = "🚫Unreachable🚫";
                navigation_cost_label.GlobalPosition = GameManager.Instance.mouse_on_hex.GlobalPosition + new Vector2(-navigation_cost_label.Size.X / 2, -50);
                reachable = false;
                return; // 🚫 Don't even try pathfinding
            }

            var path = FindPath(start, goal);
            if (path.Count == 0)
            {
                navigation_cost_label.Text = "No path";
                reachable = false;
                return;
            }

            var globalPoints = path.Select(coord => Map.placed_hexagons[coord].GlobalPosition).ToArray();
            
            navigation_line.Points = globalPoints;
            move_cost = path.Count - 1;
            navigation_cost_label.Text = (path.Count - 1).ToString();
            navigation_cost_label.GlobalPosition = GameManager.Instance.mouse_on_hex.GlobalPosition + new Vector2(-navigation_cost_label.Size.X / 2, -50);
            reachable = true;
        }
    }

    private List<Vector2I> GetHexNeighbors(Vector2I coords)
    {
        var neighbors = new List<Vector2I>();
        foreach (var direction in HEX_DIRECTIONS)
        {
            neighbors.Add(coords + direction);
        }
        return neighbors;
    }

    private int HexDistance(Vector2I a, Vector2I b)
    {
        var absVector = (a - b).Abs();
        return Math.Max(absVector.Y / 3, (Math.Abs(absVector.X) + Math.Abs(absVector.Y) / 3) / 2);
    }

    private bool IsPassable(Vector2I coords)
    {
        var hex = Map.placed_hexagons.GetValueOrDefault(coords);
        return hex != null && hex.hexagon_type != MapHexagon.HexagonType.Blocade;
    }

    public List<Vector2I> FindPath(Vector2I start, Vector2I goal)
    {
        if (start == goal)
            return new List<Vector2I> { start };

        var openSet = new List<Vector2I> { start };
        var cameFrom = new Dictionary<Vector2I, Vector2I>();
        var gScore = new Dictionary<Vector2I, int> { [start] = 0 };
        var fScore = new Dictionary<Vector2I, int> { [start] = HexDistance(start, goal) };

        while (openSet.Count > 0)
        {
            // Find node with lowest f_score
            var current = openSet.OrderBy(node => fScore.GetValueOrDefault(node, int.MaxValue)).First();

            if (current == goal)
            {
                // Reconstruct path
                var path = new List<Vector2I>();
                while (cameFrom.ContainsKey(current))
                {
                    path.Insert(0, current);
                    current = cameFrom[current];
                }
                path.Insert(0, start);
                return path;
            }

            openSet.Remove(current);

            foreach (var neighbor in GetHexNeighbors(current))
            {
                if (!IsPassable(neighbor))
                    continue;

                var tentativeGScore = gScore.GetValueOrDefault(current, int.MaxValue) + 1;

                if (tentativeGScore < gScore.GetValueOrDefault(neighbor, int.MaxValue))
                {
                    cameFrom[neighbor] = current;
                    gScore[neighbor] = tentativeGScore;
                    fScore[neighbor] = tentativeGScore + HexDistance(neighbor, goal);

                    if (!openSet.Contains(neighbor))
                        openSet.Add(neighbor);
                }
            }
        }

        return new List<Vector2I>(); // No path found
    }

    public static void MoveBee(Bee bee, Vector2I targetCoords)
    {
        if (GameManager.Instance.Navigator.reachable && bee.moves_left >= GameManager.Instance.Navigator.move_cost)
        {
            bee.moves_left -= GameManager.Instance.Navigator.move_cost;
            Map.placed_hexagons[bee.coords].units_on_hex.Remove(bee);
            var targetHex = Map.placed_hexagons[targetCoords];
            bee.coords = targetCoords;
            targetHex.units_on_hex.Add(bee);
            targetHex.SelectionEffect();
            GameManager.Instance.selected_bee = bee;
            GameManager.Instance.selected_hexagon = Map.placed_hexagons.GetValueOrDefault(targetCoords);
            if (GameManager.Instance.selected_hexagon.hexagon_type == MapHexagon.HexagonType.Beehive)
            {
                bee.GiveResourcesToHive();
            }
        }
    }
}
