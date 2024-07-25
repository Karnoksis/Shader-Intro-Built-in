using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class ComputeShaderMoving2 : MonoBehaviour
{
    public ComputeShader computeShader;
    public Material material;
    public Transform Point;
    public struct Pos
    {
        public Vector3 Position;
    }

    public Pos[] data;
    public Mesh mesh;
    public int MeshCount;
    ComputeBuffer positionBuffer;
    RenderParams rp;

    // Start is called before the first frame update
    void Start()
    {
        data = new Pos[MeshCount*MeshCount];
        positionBuffer = new ComputeBuffer(data.Length, sizeof(float) * 3);
        positionBuffer.SetData(data);
        computeShader.SetBuffer(0, "pos", positionBuffer);
        computeShader.SetFloat("count", MeshCount);

        var bounds = new Bounds(Vector3.zero, Vector3.one * 20000f);
        rp = new RenderParams(material);
        rp.worldBounds = bounds;
        rp.matProps = new MaterialPropertyBlock();
    }

    // Update is called once per frame
    void Update()
    {
        computeShader.SetVector("pointss", Point.transform.position);
        computeShader.Dispatch(0, MeshCount/16, MeshCount/16, 1);
        //positionBuffer.GetData(data);
        rp.matProps.SetBuffer("_Positions", positionBuffer);
        Graphics.RenderMeshPrimitives(rp, mesh, 0, positionBuffer.count);
    }
}
