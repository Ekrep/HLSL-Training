using System.Linq.Expressions;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class TestCide : MonoBehaviour
{

    private Vector3 _myVector;
    public enum TestEnum
    {
        a,
        b,
        c
    }

    public TestEnum tecum;
    // Start is called before the first frame update
    void Start()
    {
       
       _myVector=new Vector3(1,1,1).normalized;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
    
}
