using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TestHealthBarValueCheck : MonoBehaviour
{
    public MeshRenderer meshRenderer;
    public string value;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        value=meshRenderer.sharedMaterial.GetFloat("_OutputValue").ToString();
    }
}
