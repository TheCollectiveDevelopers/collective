using Avalonia;
using Avalonia.Controls;

namespace collective;

public partial class MainWindow : Window
{
  public MainWindow()
  {
    InitializeComponent();
    //Window config
    SystemDecorations = SystemDecorations.None;
    Topmost = true;

    var screen = Screens.Primary;
    var windowPosition = new PixelPoint(30, 0);
    if (screen != null)
    {
      windowPosition = windowPosition.WithY(screen.Bounds.Center.Y - (int) ClientSize.Height/2);
    }
    Position = windowPosition;
  }
}