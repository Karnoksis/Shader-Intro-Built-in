using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Saturation : MonoBehaviour
{
    public Shader saturationShader;
    [Range(0, 1)]
    public float sat;
    private Material saturationMat;

    void OnEnable()
    {
        saturationMat = new Material(saturationShader);
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        saturationMat.SetFloat("_Saturation", sat);
        var textureForResult = RenderTexture.GetTemporary(source.width, source.height, 0, source.format);
        Graphics.Blit(source, textureForResult, saturationMat);
        Graphics.Blit(textureForResult, destination);
        RenderTexture.ReleaseTemporary(textureForResult);
    }

    void OnDisable()
    {
        saturationMat = null;
    }
}