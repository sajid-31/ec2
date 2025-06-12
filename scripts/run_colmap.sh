#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Paths
IMAGE_DIR="../images"
WORKSPACE_DIR="../colmap_workspace"
DB_PATH="$WORKSPACE_DIR/database.db"
SPARSE_DIR="$WORKSPACE_DIR/sparse"
DENSE_DIR="$WORKSPACE_DIR/dense"

mkdir -p "$WORKSPACE_DIR"
mkdir -p "$SPARSE_DIR"
mkdir -p "$DENSE_DIR"

echo "[1/6] Running feature extraction..."
colmap feature_extractor \
    --database_path "$DB_PATH" \
    --image_path "$IMAGE_DIR"

echo "[2/6] Running exhaustive matcher..."
colmap exhaustive_matcher \
    --database_path "$DB_PATH"

echo "[3/6] Running mapper..."
colmap mapper \
    --database_path "$DB_PATH" \
    --image_path "$IMAGE_DIR" \
    --output_path "$SPARSE_DIR"

echo "[4/6] Running image undistorter..."
colmap image_undistorter \
    --image_path "$IMAGE_DIR" \
    --input_path "$SPARSE_DIR/0" \
    --output_path "$DENSE_DIR" \
    --output_type COLMAP \
    --max_image_size 2000

echo "[5/6] Running dense stereo..."
colmap patch_match_stereo \
    --workspace_path "$DENSE_DIR" \
    --workspace_format COLMAP \
    --PatchMatchStereo.geom_consistency true

echo "[6/6] Running stereo fusion..."
colmap stereo_fusion \
    --workspace_path "$DENSE_DIR" \
    --workspace_format COLMAP \
    --input_type geometric \
    --output_path "$DENSE_DIR/fused.ply"

echo "✅ 3D reconstruction complete: $DENSE_DIR/fused.ply"
