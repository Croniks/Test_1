using UnityEngine;


[ExecuteAlways]
public class ShaderHelper : MonoBehaviour
{
    [SerializeField] private Transform _transform;
    [SerializeField] private MeshRenderer _meshRenderer;
    [SerializeField] private float _tileMultiplier;
    private Material _material;


    private void Update()
    {
        if(_material == null)
        {
            _material = _meshRenderer.material;
        }
        
        _material.SetTextureScale("_MaskTex", new Vector2(_transform.localScale.x * _tileMultiplier, _transform.localScale.z * _tileMultiplier));
    }
}