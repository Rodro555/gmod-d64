$modelname "w_bfg"

$cdmaterials "models/doom64"

$surfaceprop "default"

$origin 0.000000 0.000000 0.000000 -90.000000

$scale 30.000000

$body "w_bfg" "w_bfg.SMD"

$collisionmodel "collision.SMD" {
    $concave
    $maxconvexpieces 10000
}

$sequence "idle" {
    "anims/idle.SMD"
    fps 24
    activity "ACT_VM_IDLE" 1
}
