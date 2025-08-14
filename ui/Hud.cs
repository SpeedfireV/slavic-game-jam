using Godot;

public partial class Hud : CanvasLayer
{
    public HexDescription hex_description;
    public NextTurnButton next_turn_button;
    public StatsBar stats_bar;
    private Label current_season_label;
    private ColorRect new_season_color_rect;

    public override void _Ready()
    {
        hex_description = GetNode<HexDescription>("%HexDescription");
        next_turn_button = GetNode<NextTurnButton>("%NextTurnButton");
        stats_bar = GetNode<StatsBar>("%StatsBar");
        current_season_label = GetNode<Label>("%CurrentSeasonLabel");
        new_season_color_rect = GetNode<ColorRect>("%NewSeasonColorRect");

        GameManager.Instance.Hud = this;
        GameManager.Instance.NextTurnSig += OnNextTurn;
    }

    public void ShowHexDescription(MapHexagon hexagon)
    {
        hex_description.UpdateInfo(hexagon);
        hex_description.Visible = true;
    }

    private void OnNextTurn(GameManager.Season currentSeason)
    {
        current_season_label.Text = GameManager.Instance.GetSeasonName(currentSeason);
    }

    public async void AnimateToNextSeason()
    {
        new_season_color_rect.MouseFilter = Control.MouseFilterEnum.Stop;
        var tween = CreateTween();
        tween.TweenProperty(new_season_color_rect, "color", new Color(0x000000ff), 0.4);
        await ToSignal(GetTree().CreateTimer(0.4), SceneTreeTimer.SignalName.Timeout);
        tween.TweenProperty(new_season_color_rect, "color", new Color(0x00000000), 0.4).SetDelay(0.4);
        new_season_color_rect.MouseFilter = Control.MouseFilterEnum.Pass;
    }
}
