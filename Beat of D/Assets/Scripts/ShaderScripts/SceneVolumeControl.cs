using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;


public class SceneVolumeControl : MonoBehaviour
{
   
    public VolumeProfile vProfile;
    private Vignette vignette;
    private void OnDisable()
    {
        vProfile.TryGet<Vignette>(out vignette);
        vignette.intensity.SetValue(new UnityEngine.Rendering.FloatParameter(0f));

    }

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
       
        if (Input.GetKeyDown(KeyCode.U))
        {
            vProfile.TryGet<Vignette>(out vignette);
            vignette.intensity.SetValue(new UnityEngine.Rendering.FloatParameter(1f));
            
           
        }
    }
}
