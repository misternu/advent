import plotly.graph_objects as go
import sys

def read_3d_coordinates(filename):
    """Read 3D coordinate triplets from file."""
    coords = []
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if line and ',' in line:
                parts = line.split(',')
                if len(parts) == 3:
                    x, y, z = map(float, parts)
                    coords.append((x, y, z))
                else:
                    print(f"Warning: Skipping line with {len(parts)} values: {line}")
    return coords

def visualize_3d_points(coords, color_by='z', marker_size=3):
    """Create interactive 3D scatter plot."""
    if not coords:
        print("No coordinates to visualize")
        return
    
    # Separate x, y, z coordinates
    x, y, z = zip(*coords)
    
    # Choose color scheme
    if color_by == 'z':
        colors = z
        colorbar_title = 'Z value'
    elif color_by == 'y':
        colors = y
        colorbar_title = 'Y value'
    elif color_by == 'x':
        colors = x
        colorbar_title = 'X value'
    else:
        colors = None
        colorbar_title = None
    
    # Create 3D scatter plot
    fig = go.Figure(data=[go.Scatter3d(
        x=x, y=y, z=z,
        mode='markers',
        marker=dict(
            size=marker_size,
            color=colors,
            colorscale='Viridis',
            showscale=True,
            colorbar=dict(title=colorbar_title) if colorbar_title else None
        ),
        text=[f'({x[i]:.1f}, {y[i]:.1f}, {z[i]:.1f})' for i in range(len(x))],
        hovertemplate='X: %{x}<br>Y: %{y}<br>Z: %{z}<extra></extra>'
    )])
    
    # Update layout
    fig.update_layout(
        title=f'3D Point Cloud ({len(coords)} points)',
        scene=dict(
            xaxis_title='X',
            yaxis_title='Y',
            zaxis_title='Z',
            xaxis=dict(backgroundcolor="rgb(230, 230,230)"),
            yaxis=dict(backgroundcolor="rgb(230, 230,230)"),
            zaxis=dict(backgroundcolor="rgb(230, 230,230)"),
        ),
        width=1000,
        height=800,
    )
    
    return fig

def main():
    if len(sys.argv) < 2:
        print("Usage: python visualize_3d.py <input_file> [color_by] [marker_size]")
        print("  input_file: Text file with x,y,z coordinates (one per line)")
        print("  color_by: 'x', 'y', or 'z' (default: 'z')")
        print("  marker_size: Size of points (default: 3)")
        print("\nExample: python visualize_3d.py coords_3d.txt z 5")
        sys.exit(1)
    
    input_file = sys.argv[1]
    color_by = sys.argv[2] if len(sys.argv) > 2 else 'z'
    marker_size = int(sys.argv[3]) if len(sys.argv) > 3 else 3
    
    # Read coordinates
    print(f"Reading 3D coordinates from {input_file}...")
    coords = read_3d_coordinates(input_file)
    print(f"Read {len(coords)} coordinate triplets")
    
    if not coords:
        print("No valid coordinates found")
        sys.exit(1)
    
    # Print coordinate ranges
    x, y, z = zip(*coords)
    print(f"\nCoordinate ranges:")
    print(f"  X: [{min(x):.1f}, {max(x):.1f}]")
    print(f"  Y: [{min(y):.1f}, {max(y):.1f}]")
    print(f"  Z: [{min(z):.1f}, {max(z):.1f}]")
    
    # Create and show visualization
    print("\nGenerating interactive 3D visualization...")
    print("Controls:")
    print("  - Click and drag to rotate")
    print("  - Scroll to zoom")
    print("  - Double-click to reset view")
    print("  - Hover over points to see coordinates")
    
    fig = visualize_3d_points(coords, color_by, marker_size)
    fig.show()

if __name__ == "__main__":
    main()
