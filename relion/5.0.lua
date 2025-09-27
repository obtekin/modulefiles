help([[
RELION (REgularised LIkelihood OptimisatioN) is a software package for
the refinement of macromolecular structures using cryo-electron microscopy (cryo-EM).

This module provides RELION 5.0 along with its required dependencies and
a Miniconda3 Python environment.

Version 5.0
]])

whatis("Name: RELION")
whatis("Version: 5.0")
whatis("Category: cryo-EM, structural biology, HPC")
whatis("Description: RELION 5.0 - cryo-EM image processing software with conda-based Python environment")
whatis("URL: [https://www3.mrc-lmb.cam.ac.uk/relion](https://www3.mrc-lmb.cam.ac.uk/relion)")


-- Dependencies

---

load("gnu12/12.5.0")
load("openmpi5/5.0.8")
load("fftw3/3.3.10")
load("fltk/1.3.5")
load("ghostscript/10.06")
load("libtorch/2.8.0")
load("ctffind/4.1.14")
load("cudnn/9.10.2")

-- -------------------------------------------------------------------------
-- Paths
-- -------------------------------------------------------------------------
local sharedir  = "/opt/ohpc/pub"
local category  = "apps"
local package   = "relion"
local version   = "5.0"
local root      = pathJoin(sharedir, category, package, version)
local conda     = "conda"
local condaroot   = pathJoin(sharedir, category, package, version, conda)

prepend_path("PATH",            pathJoin(root, "bin"))
prepend_path("PATH",            pathJoin(condaroot, "bin"))
prepend_path("MANPATH",         pathJoin(condaroot, "share/man"))
prepend_path("INCLUDE",         pathJoin(condaroot, "include"))
prepend_path("LD_LIBRARY_PATH", pathJoin(condaroot, "lib"))
prepend_path("LIBPATH",         pathJoin(condaroot, "lib"))
prepend_path("PYTHONPATH",      pathJoin(condaroot, "lib"))

-- -------------------------------------------------------------------------
-- Extra initialization similar to bash logic
-- -------------------------------------------------------------------------
if (mode() == "load") then
    local homedir = os.getenv("HOME")
    local condarc = pathJoin(homedir, ".conda.rc")
    local conda   = pathJoin(condaroot, "bin/conda")
    local conda_sh = pathJoin(condaroot, "etc/profile.d/conda.sh")

    -- Disable auto_activate if ~/.conda.rc is missing
    if (not isFile(condarc)) then
        execute{cmd=conda .. " config --set auto_activate_base false", modeA={"load"}}
    end

    -- Initialize conda environment properly
    if (isFile(conda_sh)) then
        -- Source conda.sh into the user shell
        execute{cmd=". " .. conda_sh, modeA={"load"}}
    else
        prepend_path("PATH", pathJoin(root, "bin"))
    end
end
