$modelname "w_saw"

$cdmaterials "models/doom64"

$surfaceprop "default"

$origin 0.000000 0.000000 0.000000 -90.000000

$scale 1.000000

$body "saw" "saw.SMD"

$collisionmodel "sawphys.SMD" {
    $concave
    $maxconvexpieces 10000
}

$sequence "idle" "anims/idle.SMD"
