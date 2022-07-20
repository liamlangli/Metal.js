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