#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <Windows.h>

using namespace std;

int main(int argc, char* argv[]) {
    
    // Check if the DLL name is provided as a command-line argument
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <DLLs>" << std::endl;
        std::cerr << "Example: " << argv[0] << " KERNEL32.DLL,NTDLL.DLL" << std::endl;
        return 1;
    }

    // Specify the name of the module (DLL) you want to check
    std::string moduleNames = argv[1];
    std::stringstream ss(moduleNames);
    std::string moduleName;

    // Split the string on commas and display each part
    while (std::getline(ss, moduleName, ',')) {
        // std::cout << "Checking  : " << moduleName << std::endl;
        // Get the module handle
        HMODULE moduleHandle = GetModuleHandleA(&moduleName[0]);

        if (moduleHandle != nullptr) {
            //std::cout << "Modules "<< moduleName << " Found !" << std::endl;
            return 0;
        }
    }

    //std::cout << "No module found" << std::endl;
    return 1;
}
