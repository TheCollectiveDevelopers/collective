using Avalonia;
using Avalonia.Controls;
using Avalonia.Platform;

namespace collective;

public partial class MainWindow : Window
{
  public MainWindow()
  {
    InitializeComponent();
    SystemDecorations = SystemDecorations.None;
    var screen = Screens.Primary;
    var windowPosition = new PixelPoint(30, 0);
    if (screen != null)
    {
      windowPosition = windowPosition.WithY(screen.Bounds.Center.Y);
    }
    Position = windowPosition;
  }
}