$modelname "w_chg"

$cdmaterials "models/doom64"

$surfaceprop "default"

$origin 0.000000 0.000000 0.000000 -90.000000

$scale 1.000000

$body "chg" "chg.SMD"

$collisionmodel "phys.SMD" {
    $concave
    $maxconvexpieces 10000
}

$sequence "idle" "anims/idle.SMD"
