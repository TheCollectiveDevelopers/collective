using System.Collections.ObjectModel;
using Avalonia;
using Avalonia.Controls;
using Avalonia.Input;
using Avalonia.Media.Imaging;
using Avalonia.Diagnostics;
using System.Diagnostics;

namespace collective;

public partial class MainWindow : Window
{
  public ObservableCollection<Bitmap> References { get; set; } = [];
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
      windowPosition = windowPosition.WithY(screen.Bounds.Center.Y - (int)ClientSize.Height / 2);
    }
    Position = windowPosition;

    //event handlers
    AddHandler(DragDrop.DragOverEvent, DragOver);
    AddHandler(DragDrop.DropEvent, Drop);
  }

  private void DragOver(object? sender, DragEventArgs e)
  {
    System.Console.WriteLine("happye");
    if (e.Data.Contains(DataFormats.FileNames))
      e.DragEffects = DragDropEffects.Copy;
    else
      e.DragEffects = DragDropEffects.None;

    e.Handled = true;
  }

  private void Drop(object? sender, DragEventArgs e)
  {
    Debug.Print("Hi there");
    if (e.Data.Contains(DataFormats.Files))
    {
      var files = e.Data.GetFiles();
      if (files != null)
      {
        foreach (var file in files)
        {
          Debug.Print(file.Path.AbsolutePath);
          References.Add(ImageHelper.LoadFromResource(file.Path));
          EmptyScreen.IsVisible = false;
        }
      }
    }
  }
}