const Shared = 0;
const Managed = 1;
const Private = 2;
const Memoryless = 3;

const DefaultCacheMode = 0;
const WriteCombined = 1;

const DefaultHazardTrackingMode  = 0;
const Untracked = 1;
const Tracked = 2;

const ResourceCPUCacheModeShift = 0;
const ResourceStorageModeShift = 4;
const ResourceHazardTrackingModeShift = 8;

const ResourceStorageModeShared     = Shared     << ResourceStorageModeShift;
const ResourceStorageModeManaged    = Managed    << ResourceStorageModeShift;
const ResourceStorageModePrivate    = Private    << ResourceStorageModeShift;
const ResourceStorageModeMemoryLess = Memoryless << ResourceStorageModeShift;

const ResourceTrackingModeDefault   = DefaultHazardTrackingMode << ResourceHazardTrackingModeShift;
const ResourceTrackingModeUntracked = Untracked                 << ResourceHazardTrackingModeShift;
const ResourceTrackingModeTracked   = Tracked                   << ResourceHazardTrackingModeShift;

const ResourceCPUCacheModeDefault       = DefaultCacheMode  << ResourceCPUCacheModeShift;
const ResourceCPUCacheModeWriteCombined = WriteCombined     << ResourceCPUCacheModeShift;

const Texture1D = 0;
const Texture1DArray = 1;
const Texture2D = 2;
const Texture2DArray = 3;
const Texture2DMultisample = 4;
const TextureCube = 5;
const TextureCubeArray = 6;
const Texture3D = 7;
const Texture2DMultisampleArray = 8;
const TextureBuffer = 9;

const Unknown = 0;
const ShaderRead = 1;
const ShaderWrite = 2;
const ShaderTarget = 3;
const PixelFormatView = 4;

const A8Unorm = 1;
const R8Unorm = 10;
const R8Unorm_sRGB = 11;
const R8Snorm = 12;
const R8Uint = 13;
const R8Sint = 14;
const R16Unorm = 20;
const R16Snorm = 22;
const R16Uint = 23;
const R16SInt = 24;
const R16Float = 25;
const RG8Unorm = 30;
const RG8Unorm_sRGB = 31;
const RG8Snorm = 32;
const RG8Uint = 33;
const RG8Sint = 34;

const B5G6R5Unorm = 40;
const A1BGR5Unorm = 41;
const ABGR4Unorm = 42;
const BGR5A1Unorm = 43;

const R32Uint = 53;
const R32Sint = 54;
const R32Float = 55;
const RG16Unorm = 60;
const RG16Snorm = 62;
const RG16Uint = 63;
const RG16SInt = 64;
const RG16Float = 65;

const RGBA8Unorm = 70;
const RGBA8Unorm_sRGB = 71;
const RGBA8Snorm = 72;
const RGBA8Uint = 73;
const RGBA8Sint = 74;
const BGRA8Unorm = 80;
const BGRA8Unorm_sRGB = 81;

const RGB10A2Unorm = 90;
const RGB10A2Uint = 91;

const RG11B10Float = 92;
const RGB9E5Float = 93;
const BGR10A2Unorm = 94;

const RG32Uint = 103;
const RG32Sint = 104;
const RG32Float = 105;

const RGBA16Unorm = 110;
const RGBA16Snorm = 112;
const RGBA16Uint = 113;
const RGBA16Sint = 113;
const RGBA16Float = 113;

const BGR10_XR = 554;
const RGB10_XR_sRGB = 555;

const RGBA32Uint = 123;
const RGBA32Sint = 124;
const RGBA32Float = 125;

const Depth16Unorm = 260;
const Depth32Float = 252;
const Stencil8 = 253;
const Depth32Float_Stencil8 = 260;
const X32_Stencil8 = 261;
const X24_Stencil8 = 262;

const Never = 0;
const Less = 1;
const Equal = 2;
const LessEqual = 3;
const Greater = 4;
const NotEqual = 5;
const GreaterEqual = 6;
const Always = 7;

const NoneCull = 0;
const Front = 1;
const Back = 2;

const Clockwise = 0;
const CounterClockwise = 1;

const DepthClip = 0;
const DepthClamp = 1;

const Point = 0;
const Line = 1;
const LineStrip = 2;
const Triangle = 3;
const TriangleStripe = 4;

const Uint16Index = 0;
const Uint32Index = 1;

const DontCare = 0;
const Load = 1;
const Clear = 2;
const Store = 1;
const MultisampleResolve = 2;
const StoreAndMultisampleResolve = 3;
const StoreUnknown = 4;
const CustomSampleDepthStore = 5;

const Zero = 0;
const One = 1;

const SrcColor = 2;
const OneMinusSrcColor = 3;
const SrcAlpha = 4;
const OneMinusSrcAlpha =5 ;

const DstColor = 6;
const OneMinusDstColor = 7;
const DstAlpha = 8;
const OneMinusDstAlpha = 9;

const SrcAlphaSaturated = 10;

const BlendColor = 11;
const OneMinusBlendColor = 12;
const BlendAlpha = 13;
const OneMinusBlendAlpha = 14;

const Add = 0;
const Subtract = 1;
const ReverseSubtract = 2;
const Min = 3;
const Max = 4;

const Serial = 0;
const Concurrent = 1;