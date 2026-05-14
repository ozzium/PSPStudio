function Get-PSPOhMyPoshThemes {

    $themeNames = @(
        "cobalt2",
        "paradox",
        "atomic",
        "jandedobbeleer",
        "agnoster",
        "dracula",
        "tokyonight_storm",
        "night-owl",
        "powerline",
        "powerlevel10k_classic",
        "catppuccin",
        "space",
        "takuya",
        "blueish",
        "clean-detailed",
        "cloud-native-azure",
        "pure",
        "quick-term",
        "robbyrussell",
        "slim",
        "spaceship",
        "zash"
    )

    foreach ($name in $themeNames) {
        [pscustomobject]@{
            Name = $name
            Path = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$name.omp.json"
            Source = "Remote"
        }
    }
}