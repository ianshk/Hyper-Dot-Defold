local M = {} -- public interface


-- Unity ad stuff
local REWARDED = "rewardedVideo"
local VIDEO = "video"
local TEST_MODE = false

local app_id = 0
M.video_available = 0
M.rewarded_available = 0
M.rewarded_pressed = 0


local function unity_ads_callback(self, msg_type, message)
	if msg_type == unityads.TYPE_IS_READY then
	  print(message.placementId, " is ready")
	  --btn_ready(self, message.placementId)
	elseif msg_type == unityads.TYPE_DID_START then
	  print(message.placementId, " started")
	elseif msg_type == unityads.TYPE_DID_ERROR then
	  print(message.message)
	  -- errors info https://github.com/Unity-Technologies/unity-ads-ios/wiki/sdk_ios_api_errors
	  if message.error == unityads.ERROR_NOT_INITIALIZED then
		print("kUnityAdsErrorNotInitialized")
	  elseif message.error == unityads.ERROR_INITIALIZED_FAILED then
		print("kUnityAdsErrorInitializedFailed")
	  elseif message.error == unityads.ERROR_INVALID_ARGUMENT then
		print("kUnityAdsErrorInvalidArgument")
	  elseif message.error == unityads.ERROR_VIDEO_PLAYER then
		print("kUnityAdsErrorVideoPlayerError")
	  elseif message.error == unityads.ERROR_INIT_SANITY_CHECK_FAIL then
		print("kUnityAdsErrorInitSanityCheckFail")
	  elseif message.error == unityads.ERROR_AD_BLOCKER_DETECTED then
		print("kUnityAdsErrorAdBlockerDetected")
	  elseif message.error == unityads.ERROR_FILE_IO then
		print("kUnityAdsErrorFileIoError")
	  elseif message.error == unityads.ERROR_DEVICE_ID then
		print("kUnityAdsErrorDeviceIdError")
	  elseif message.error == unityads.ERROR_SHOW then
		print("kUnityAdsErrorShowError")
	  elseif message.error == unityads.ERROR_INTERNAL then
		print("kUnityAdsErrorInternalError")
	  end
	elseif msg_type == unityads.TYPE_DID_FINISH then
	  --all finish states info https://github.com/Unity-Technologies/unity-ads-ios/wiki/sdk_ios_api_finishstates
	  if message.state == unityads.FINISH_STATE_ERROR then
		print("kUnityAdsFinishStateError")
	  elseif message.state == unityads.FINISH_STATE_SKIPPED then
		print("kUnityAdsFinishStateSkipped")
	  elseif message.state == unityads.FINISH_STATE_COMPLETED then
		 print("kUnityAdsFinishStateCompleted")
        if M.rewarded_pressed == 1 then
            print("rewarded pressed")
			msg.post("/game#game", "revive")
		end
	  end
	end
end


local function set_callback(self)
	if unityads then
	  print("Set Callback!")
	  unityads.setCallback(unity_ads_callback)
	end
end


local function get_app_id(self)
    local sys_name = sys.get_sys_info().system_name
    if sys_name == "Android" then
    	app_id = "0000000" -- Replace with android unity ID
    	print("Android app id " .. app_id)
    elseif sys_name == "iPhone OS" then
        app_id = "0000000" -- Replace with iOS unity ID
        print("apple app id " .. app_id)
    end
end

local function show_ad(self, placementId)
    if unityads then
    	if placementId then
			unityads.show(placementId)
	  	else
			unityads.show()
	  	end
	end
end

function M.show_video_ad(self)
	print("Show video ad")
	show_ad(self, VIDEO)
end


function M.show_rewarded_ad(self)
	print("Show rewarded ad")
	show_ad(self, REWARDED)
end


function M.remove_callback(self)
    if unityads then
        print("Remove Callback!")
        unityads.setCallback(nil)
    end
end


function M.init_ads(self)
    print("----- Init ads")
    get_app_id(self)
    if unityads then
        unityads.setDebugMode(TEST_MODE)
        print("VERSION IS: ", unityads.getVersion())
        print("DEBUG MODE IS:", unityads.getDebugMode())
        print("isInitialized:", unityads.isInitialized())
        print("isSupported:", unityads.isSupported())
        print("isReady(video):", unityads.isReady(VIDEO))
        print("isReady(rewardedVideo):", unityads.isReady(REWARDED))
        print("isReady():", unityads.isReady())

        set_callback(self)

        if not unityads.isInitialized() then
			print("Init SDK with id", app_id)
			unityads.initialize(app_id, unity_ads_callback, TEST_MODE)
		else
			print("UnityADS already inited. Just set callback one more time")
			set_callback(self)
			if unityads.isReady(REWARDED) then
                print("Init: Rewarded ad ready")
                M.video_available = 1
			end
			if unityads.isReady(VIDEO) then
				print("Init: Video ad ready")
                 M.rewarded_available = 1
			end
		end
    end
end

return M