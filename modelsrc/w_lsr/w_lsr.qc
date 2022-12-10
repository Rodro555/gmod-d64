$modelname "w_lsr"

$cdmaterials "models/doom64"

$surfaceprop "default"

$origin 0.000000 0.000000 0.000000 -90.000000

$scale 1.000000

$body "lsr" "lsr.SMD"

$collisionmodel "phys.SMD" {
    $concave
    $maxconvexpieces 10000
}

$sequence "idle" "anims/idle.SMD"
