using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ComputeSimpleRun : MonoBehaviour
{
    public ComputeShader computeShader;
    public Material material;
    public Mesh mesh;
    public int MeshCount;
    ComputeBuffer positionsBuffer;
    Vector3[] Positions;
    RenderParams renderParams;
    //public 
    // Start is called before the first frame update
    void Start()
    {
        //Заполняем массив позициями
        Positions = new Vector3[MeshCount*MeshCount];
        for (int i = 0; i < MeshCount; i++)
        {
            for (int j = 0; j < MeshCount; j++)
            {
                Positions[j+MeshCount*i].x = j;
                Positions[j+MeshCount*i].z = i;
            }
        }

        int kernel = computeShader.FindKernel("ComputeSimple");
        positionsBuffer = new ComputeBuffer(Positions.Length, sizeof(float) * 3);
        positionsBuffer.SetData(Positions);
        computeShader.SetBuffer(kernel, "Positions", positionsBuffer);

        var bounds = new Bounds(Vector3.zero, Vector3.one * 20000f);
        renderParams = new RenderParams(material);
        renderParams.worldBounds = bounds;
        renderParams.matProps = new MaterialPropertyBlock();
        renderParams.matProps.SetBuffer("_Positions", positionsBuffer);
    }

    // Update is called once per frame
    void Update()
    {
        int kernel = computeShader.FindKernel("ComputeSimple");
        computeShader.Dispatch(kernel, positionsBuffer.count / 8, 1, 1);
        //positionsBuffer.GetData(Positions);
        //Debug.Log(Positions[0].y);
        Graphics.RenderMeshPrimitives(renderParams, mesh, 0, positionsBuffer.count);
    }
}
