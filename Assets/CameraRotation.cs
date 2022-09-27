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
    //��axis����תangle�Ƕ�
    Quaternion rotation = Quaternion.AngleAxis(angle, axis);
    //��ת֮ǰ,��centerΪ���,transform.position��ǰ����λ��Ϊ�յ������.
    Vector3 beforeVector = transform.position - center;
    //��Ԫ�� * ����(���ܵ���λ��, �������������)
    Vector3 afterVector = rotation * beforeVector;//��ת�������
                                                  //�������յ� = ��������� + ����
    transform.position = afterVector + center;

    //����Sphere,ʹZ��ָ��Sphere
    transform.LookAt(Sphere.transform.position);
  }
}
