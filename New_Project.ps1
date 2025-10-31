# Define the base directory (use current directory)
$base = Get-Location

# Define directory structure
$dirs = @(
    "_layouts",
    "_includes",
    "_posts",
    "_sass",
    "assets/css"
)

# Define files to touch
$files = @(
    "_config.yml",
    "_layouts/default.html",
    "_layouts/post.html",
    "_layouts/page.html",
    "_includes/header.html",
    "_includes/footer.html",
    "_includes/nav.html",
    "_posts/2025-01-15-getting-started-with-kubernetes.md",
    "_posts/2025-02-20-mastering-git-workflows.md",
    "_posts/2025-03-10-docker-best-practices.md",
    "_sass/main.scss",
    "assets/css/style.scss",
    "about.md",
    "index.html",
    "Gemfile"
)

# Create directories if they don't exist
foreach ($dir in $dirs) {
    $path = Join-Path $base $dir
    if (-not (Test-Path $path)) {
        Write-Host "Creating directory: $path"
        New-Item -ItemType Directory -Path $path | Out-Null
    }
}

# Create (touch) files
foreach ($file in $files) {
    $path = Join-Path $base $file
    if (-not (Test-Path $path)) {
        Write-Host "Creating file: $path"
        New-Item -ItemType File -Path $path | Out-Null
    } else {
        # Update last modified time (touch behavior)
        (Get-Item $path).LastWriteTime = Get-Date
        Write-Host "Touched existing file: $path"
    }
}

Write-Host "`nStructure setup complete."
