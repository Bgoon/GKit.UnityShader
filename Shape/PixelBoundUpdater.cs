using GKitForUnity;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR
[ExecuteInEditMode]
#endif
public class PixelBoundUpdater : MonoBehaviour {
	private Material material;
	private new Renderer renderer;

	private void Start() {
		renderer = GetComponent<Renderer>();
		FindMaterial();
	}
	private void Update() {
#if UNITY_EDITOR
		renderer = GetComponent<Renderer>();
		if (renderer == null)
			return;
		FindMaterial();
#endif

		Vector2 boundSize = renderer.GetBoundSize();
		material.SetVector("_BoundSize", new Vector4(boundSize.x, boundSize.y, 1f / boundSize.x, 1f / boundSize.y));
	}

	private void FindMaterial() {
		material = renderer.sharedMaterial;
	}
}