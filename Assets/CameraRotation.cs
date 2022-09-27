using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraRotation : MonoBehaviour
{
  [SerializeField] private Transform Sphere;

  float distance;
    // Start is called before the first frame update
    void Start()
     {
    
    }

    // Update is called once per frame
    void Update()
    {
    transform.RotateAround(Sphere.position, Sphere.up, 72 * Time.deltaTime);
    }

  private void RotateAround(Vector3 center, Vector3 axis, float angle)
  {
    //绕axis轴旋转angle角度
    Quaternion rotation = Quaternion.AngleAxis(angle, axis);
    //旋转之前,以center为起点,transform.position当前物体位置为终点的向量.
    Vector3 beforeVector = transform.position - center;
    //四元数 * 向量(不能调换位置, 否则发生编译错误)
    Vector3 afterVector = rotation * beforeVector;//旋转后的向量
                                                  //向量的终点 = 向量的起点 + 向量
    transform.position = afterVector + center;

    //看向Sphere,使Z轴指向Sphere
    transform.LookAt(Sphere.transform.position);
  }
}
