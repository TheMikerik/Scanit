# Development of a 3D Object Scanning Application

## Project Goal
Create a mobile application that enables users to create 3D scans of objects using TrueDepth (FaceID) technology on iPhones. This sensor measures the distance of individual pixels and allows for accurate 3D measurement and reconstruction of objects.

## Key Features and Functions

1. **RGBD Image Capture**: 
   - Capture at least three images of objects from different angles.
   - Data includes pixel distances and color information.
   - The object must be visible and centrally placed on the screen.
   - Segmentation for better separation of the object from the background.

2. **Calibration and Compensation**:
   - Calibration metadata to compensate for physical influences.
   - Ensure measurement accuracy and eliminate distortions.

3. **Data Conversion to 3D Mesh (OBJ)**:
   - Automatic conversion of point cloud data to a 3D mesh model with color data.
   - Segmentation to define the area of interest and noise removal.

## Technical and Functional Requirements
- Compatibility with the latest sensors and mobile device technologies.
- Intuitive and user-friendly interface.
- Ability to scan various types and sizes of objects.

## Techniques and Methods
- Iterative Closest Point (ICP) method for point cloud data alignment.
- Image segmentation and noise filtering (median filter, Gaussian filter).
- Image processing and computer vision (OpenCV).
- PointCloud Library (PCL) for point cloud processing.
- AVFoundation for handling audiovisual content and RGBD imaging.

## Programming Languages
- Swift
- Objective-C

## Important Links
- [Figma](https://www.figma.com/design/JQ103mUxXS9Ugs0N8UXS3N/Untitled?node-id=0-1&t=sdMCXFaEK2RYcmlx-1)
- [Github](https://github.com/TheMikerik/Scanit)
