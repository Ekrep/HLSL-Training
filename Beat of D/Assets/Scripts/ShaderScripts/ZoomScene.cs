using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ZoomScene : MonoBehaviour
{
    [SerializeField]
    private Material _zoomMat;


    public MeshFilter sphereMesh;

    private Vector3[] vertices, modifiedVerts;

    [SerializeField]
    private float radius = 2f;

    [SerializeField]
    private float deformationStrength = 2f;

    void Start()
    {
        vertices = sphereMesh.mesh.vertices;
        modifiedVerts = sphereMesh.mesh.vertices;
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector2 screenPixels = Camera.main.WorldToScreenPoint(gameObject.transform.position);
        screenPixels = new Vector2(screenPixels.x / Screen.width, screenPixels.y / Screen.height);

        _zoomMat.SetVector("_ObjectScreenPosition", screenPixels);
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            Physics.Raycast(ray, out hit, Mathf.Infinity);

            for (int i = 0; i < modifiedVerts.Length; i++)
            {
                Vector3 distance = modifiedVerts[i] - hit.point;

                float smoothingFactor = 2f;
                float force = deformationStrength / (1f + hit.point.sqrMagnitude);

                if (distance.sqrMagnitude<radius)
                {
                    modifiedVerts[i] = modifiedVerts[i] + (Vector3.down * force) / smoothingFactor;
                }
               

            }
            RecalculatMeshes();

        }
       

        
    }


    private void RecalculatMeshes()
    {
        sphereMesh.mesh.vertices = modifiedVerts;
        gameObject.GetComponent<MeshCollider>().sharedMesh = sphereMesh.mesh;
        sphereMesh.mesh.RecalculateNormals();

    }


}
