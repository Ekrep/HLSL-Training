using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OrbitMotion : MonoBehaviour
{
    public Transform orbittingObject;
    public OrbitPath path;

    [Range(0, 1)]
    public float orbitProgress=0f;
    public float orbitPeriod = 3f;
    public bool isOrbitActive = true;

    public float orbitSpeed=1f;


    //sunmass
    //planetmass
    void Start()
    {
        if (orbittingObject==null)
        {
            isOrbitActive = false;
            return;
        }
        SetOrbitPos();
        StartCoroutine(AnimateOrbit()); 

    }

   private void SetOrbitPos()
    {
        Vector2 orbitPos = path.Evaluate(orbitProgress);
        orbittingObject.localPosition = new Vector3(orbitPos.x, 0, orbitPos.y);
    }

    IEnumerator AnimateOrbit()
    {
        if (orbitPeriod<0.1f)
        {
            orbitPeriod = 0.1f;
        }
        float calculatedOrbitSpeed= orbitSpeed / orbitPeriod;
        while (isOrbitActive)
        {
            orbitProgress += Time.deltaTime * calculatedOrbitSpeed;
            orbitProgress %= 1f;
            SetOrbitPos();
            yield return null;
        }





    }
}
