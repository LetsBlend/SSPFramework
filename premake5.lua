workspace "OceanSimulation"
	architecture "x64"
	
	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["glm"] = "OceanSimulation/vendor/glm"
IncludeDir["spdlog"] = "OceanSimulation/vendor/spdlog"
IncludeDir["ImGui"] = "OceanSimulation/vendor/imgui"
IncludeDir["ImGuiBackends"] = "OceanSimulation/vendor/imgui/backends"
IncludeDir["Assimp"] = "OceanSimulation/vendor/assimp/include"

include "OceanSimulation/vendor/imgui"

project "OceanSimulation"
	location "OceanSimulation"
	kind "ConsoleApp"
	language "C++"

	targetdir("bin/" .. outputdir .. "/%{prj.name}")
	objdir("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "pch.h"
	pchsource "%{prj.name}/src/pch.cpp"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"%{prj.name}/vendor",
		"%{prj.name}/src",
		"%{IncludeDir.glm}",
		"%{IncludeDir.spdlog}",
		"%{IncludeDir.ImGui}",
		"%{IncludeDir.ImGuiBackends}",
		"%{IncludeDir.Assimp}"
	}

	libdirs
	{
		"%{prj.name}/vendor/assimp/lib/x64/"
	}

	links
	{
		"ImGui",
		"assimp-vc143-mt.lib"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

	defines
	{
		"PLATFROM_WINDOWS",
		"ASSERTION_ENABLED"
	}

	postbuildcommands
    {
        ("{COPY} ../%{prj.name}/Assets ../bin/" .. outputdir .. "/%{prj.name}/Assets")
    }

	filter "configurations:Debug"
		defines "DEBUG"
		symbols "On"

	filter "configurations:Release"
		defines "RELEASE"
		optimize "On"

	filter "configurations:Dist"
		defines "DIST"
		optimize "On"