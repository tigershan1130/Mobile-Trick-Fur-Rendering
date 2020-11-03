# Mobile-Trick-Fur-Rendering
A cheap trick for fur rendering on Mobile doesn't require multi-tap pass using Unity's new URP render pipeline.

This is a cheap trick using Unity's URP render pipeline to render fur.

We generate 2 UV channels for Fur Shader, Fur shader is cutout shader, and we use alpha channel to control the effect of fur.
The cutout channel uses UV0 and Fur details uses UV1.

Support Unity's URP render pipeline.
![alt text](https://github.com/tigershan1130/Mobile-Trick-Fur-Rendering/blob/main/ScreenShot.jpg)
