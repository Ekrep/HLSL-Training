using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[ExecuteInEditMode]
public class LayoutGroupper : MonoBehaviour
{

    public List<RectTransform> uiElements;
    public GameObject a;

    [SerializeField]
    private bool _adjustSize;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (_adjustSize)
        {
            for (int i = 0; i < uiElements.Count; i++)
            {
                if (i>0)
                {
                    uiElements[i].transform.position = new Vector2(uiElements[i - 1].transform.position.x + 130f,uiElements[i].transform.position.y);
                }
                
            }

            _adjustSize = false;
        }
    }
}
