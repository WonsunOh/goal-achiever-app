from PIL import Image, ImageDraw
import math

def create_app_icon(size=1024):
    """Create a Goal Achiever app icon with modern design"""

    # Create image with gradient-like background
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Colors from app theme
    primary = (99, 102, 241)  # #6366F1 Indigo
    primary_dark = (79, 70, 229)  # #4F46E5
    secondary = (16, 185, 129)  # #10B981 Green (success)
    white = (255, 255, 255)

    # Draw rounded rectangle background with gradient effect
    corner_radius = size // 5

    # Create gradient background
    for y in range(size):
        ratio = y / size
        r = int(primary[0] * (1 - ratio * 0.3) + primary_dark[0] * ratio * 0.3)
        g = int(primary[1] * (1 - ratio * 0.3) + primary_dark[1] * ratio * 0.3)
        b = int(primary[2] * (1 - ratio * 0.3) + primary_dark[2] * ratio * 0.3)
        draw.line([(0, y), (size, y)], fill=(r, g, b, 255))

    # Create mask for rounded corners
    mask = Image.new('L', (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, size-1, size-1], radius=corner_radius, fill=255)

    # Apply mask
    img.putalpha(mask)

    # Draw a stylized mountain/goal peak with checkmark
    center_x = size // 2
    center_y = size // 2

    # Mountain/Achievement Peak
    peak_height = int(size * 0.35)
    peak_width = int(size * 0.5)

    mountain_points = [
        (center_x, center_y - peak_height),  # Top peak
        (center_x + peak_width // 2, center_y + peak_height // 2),  # Right bottom
        (center_x - peak_width // 2, center_y + peak_height // 2),  # Left bottom
    ]

    # Draw mountain with white color
    draw.polygon(mountain_points, fill=white)

    # Draw checkmark on top of the peak
    check_start_x = center_x - int(size * 0.12)
    check_start_y = center_y - int(size * 0.05)
    check_mid_x = center_x - int(size * 0.02)
    check_mid_y = center_y + int(size * 0.08)
    check_end_x = center_x + int(size * 0.18)
    check_end_y = center_y - int(size * 0.15)

    check_width = int(size * 0.06)

    # Draw checkmark with green color
    draw.line([(check_start_x, check_start_y), (check_mid_x, check_mid_y)],
              fill=secondary, width=check_width)
    draw.line([(check_mid_x, check_mid_y), (check_end_x, check_end_y)],
              fill=secondary, width=check_width)

    # Add rounded ends to checkmark
    draw.ellipse([check_start_x - check_width//2, check_start_y - check_width//2,
                  check_start_x + check_width//2, check_start_y + check_width//2],
                 fill=secondary)
    draw.ellipse([check_mid_x - check_width//2, check_mid_y - check_width//2,
                  check_mid_x + check_width//2, check_mid_y + check_width//2],
                 fill=secondary)
    draw.ellipse([check_end_x - check_width//2, check_end_y - check_width//2,
                  check_end_x + check_width//2, check_end_y + check_width//2],
                 fill=secondary)

    # Add rising arrow/progress bars at the bottom
    bar_width = int(size * 0.08)
    bar_gap = int(size * 0.04)
    bar_start_x = center_x - int(size * 0.25)
    bar_bottom = center_y + int(size * 0.38)

    bar_heights = [0.12, 0.18, 0.24]  # Progressive heights

    for i, h in enumerate(bar_heights):
        x = bar_start_x + i * (bar_width + bar_gap)
        bar_height = int(size * h)
        # Draw bar with rounded top
        draw.rounded_rectangle(
            [x, bar_bottom - bar_height, x + bar_width, bar_bottom],
            radius=bar_width // 3,
            fill=(255, 255, 255, 200)
        )

    return img


def create_app_icon_v2(size=1024):
    """Create a cleaner Goal Achiever app icon - Version 2"""

    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Colors
    primary = (99, 102, 241)  # #6366F1 Indigo
    primary_dark = (79, 70, 229)  # #4F46E5
    secondary = (16, 185, 129)  # #10B981 Green
    white = (255, 255, 255)

    corner_radius = size // 5

    # Create gradient background
    for y in range(size):
        ratio = y / size
        r = int(primary[0] + (primary_dark[0] - primary[0]) * ratio * 0.5)
        g = int(primary[1] + (primary_dark[1] - primary[1]) * ratio * 0.5)
        b = int(primary[2] + (primary_dark[2] - primary[2]) * ratio * 0.5)
        draw.line([(0, y), (size, y)], fill=(r, g, b, 255))

    # Create mask for rounded corners
    mask = Image.new('L', (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, size-1, size-1], radius=corner_radius, fill=255)
    img.putalpha(mask)

    center_x = size // 2
    center_y = size // 2

    # Draw a circular target/goal ring
    ring_radius = int(size * 0.32)
    ring_width = int(size * 0.04)

    # Outer ring
    draw.ellipse([center_x - ring_radius, center_y - ring_radius,
                  center_x + ring_radius, center_y + ring_radius],
                 outline=white, width=ring_width)

    # Inner filled circle
    inner_radius = int(size * 0.15)
    draw.ellipse([center_x - inner_radius, center_y - inner_radius,
                  center_x + inner_radius, center_y + inner_radius],
                 fill=white)

    # Checkmark in the center
    check_size = int(size * 0.12)
    check_width = int(size * 0.04)

    check_start = (center_x - check_size, center_y)
    check_mid = (center_x - check_size // 3, center_y + check_size // 2)
    check_end = (center_x + check_size, center_y - check_size // 2)

    draw.line([check_start, check_mid], fill=secondary, width=check_width)
    draw.line([check_mid, check_end], fill=secondary, width=check_width)

    # Rounded caps
    for point in [check_start, check_mid, check_end]:
        draw.ellipse([point[0] - check_width//2, point[1] - check_width//2,
                      point[0] + check_width//2, point[1] + check_width//2],
                     fill=secondary)

    # Add upward arrow indicating progress
    arrow_x = center_x + int(size * 0.28)
    arrow_y = center_y
    arrow_height = int(size * 0.25)
    arrow_width = int(size * 0.035)

    # Arrow shaft
    draw.line([(arrow_x, arrow_y + arrow_height // 2),
               (arrow_x, arrow_y - arrow_height // 2)],
              fill=secondary, width=arrow_width)

    # Arrow head
    head_size = int(size * 0.08)
    draw.polygon([
        (arrow_x, arrow_y - arrow_height // 2 - head_size // 2),
        (arrow_x - head_size, arrow_y - arrow_height // 2 + head_size // 2),
        (arrow_x + head_size, arrow_y - arrow_height // 2 + head_size // 2),
    ], fill=secondary)

    return img


def create_app_icon_v3(size=1024):
    """Create Goal Achiever app icon - Version 3: Flag on mountain peak"""

    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Colors
    primary = (99, 102, 241)  # #6366F1 Indigo
    primary_light = (129, 140, 248)  # #818CF8
    secondary = (16, 185, 129)  # #10B981 Green
    white = (255, 255, 255)

    corner_radius = size // 5

    # Create gradient background (top to bottom, light to dark)
    for y in range(size):
        ratio = y / size
        r = int(primary_light[0] + (primary[0] - primary_light[0]) * ratio)
        g = int(primary_light[1] + (primary[1] - primary_light[1]) * ratio)
        b = int(primary_light[2] + (primary[2] - primary_light[2]) * ratio)
        draw.line([(0, y), (size, y)], fill=(r, g, b, 255))

    # Create mask for rounded corners
    mask = Image.new('L', (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, size-1, size-1], radius=corner_radius, fill=255)
    img.putalpha(mask)

    center_x = size // 2
    center_y = size // 2

    # Draw stylized mountain
    peak_x = center_x
    peak_y = center_y - int(size * 0.2)
    base_y = center_y + int(size * 0.35)
    width = int(size * 0.6)

    mountain_points = [
        (peak_x, peak_y),
        (peak_x + width // 2, base_y),
        (peak_x - width // 2, base_y),
    ]
    draw.polygon(mountain_points, fill=white)

    # Flag pole
    pole_height = int(size * 0.25)
    pole_width = int(size * 0.025)
    pole_x = peak_x
    pole_top = peak_y - pole_height

    draw.rectangle([pole_x - pole_width // 2, pole_top,
                    pole_x + pole_width // 2, peak_y],
                   fill=secondary)

    # Flag
    flag_width = int(size * 0.12)
    flag_height = int(size * 0.08)

    flag_points = [
        (pole_x + pole_width // 2, pole_top),
        (pole_x + pole_width // 2 + flag_width, pole_top + flag_height // 2),
        (pole_x + pole_width // 2, pole_top + flag_height),
    ]
    draw.polygon(flag_points, fill=secondary)

    # Small star/sparkle near flag
    star_x = pole_x + int(size * 0.15)
    star_y = pole_top + int(size * 0.02)
    star_size = int(size * 0.03)

    # Draw 4-point star
    draw.polygon([
        (star_x, star_y - star_size),
        (star_x + star_size // 3, star_y),
        (star_x, star_y + star_size),
        (star_x - star_size // 3, star_y),
    ], fill=(255, 255, 255, 200))
    draw.polygon([
        (star_x - star_size, star_y),
        (star_x, star_y + star_size // 3),
        (star_x + star_size, star_y),
        (star_x, star_y - star_size // 3),
    ], fill=(255, 255, 255, 200))

    return img


if __name__ == "__main__":
    import os
    os.makedirs("assets/icons", exist_ok=True)

    # Generate all versions
    icon_v1 = create_app_icon(1024)
    icon_v1.save("assets/icons/app_icon_v1.png")
    print("Created app_icon_v1.png (Mountain with checkmark)")

    icon_v2 = create_app_icon_v2(1024)
    icon_v2.save("assets/icons/app_icon_v2.png")
    print("Created app_icon_v2.png (Target with checkmark)")

    icon_v3 = create_app_icon_v3(1024)
    icon_v3.save("assets/icons/app_icon_v3.png")
    print("Created app_icon_v3.png (Mountain with flag)")

    # Use v3 as the main icon (flag on mountain - represents goal achievement)
    icon_v3.save("assets/icons/app_icon.png")
    print("\nMain icon saved as app_icon.png")

    print("\nAll icons generated successfully!")
