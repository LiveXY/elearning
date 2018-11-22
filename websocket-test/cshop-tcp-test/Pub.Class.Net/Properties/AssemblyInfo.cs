using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

// 有关程序集的常规信息通过下列属性集
// 控制。更改这些属性值可修改
// 与程序集关联的信息。
#if NETCLIENT
[assembly: AssemblyTitle("Pub.Class.NetClient")]
#else
[assembly: AssemblyTitle("Pub.Class.Net")]
#endif
[assembly: AssemblyDescription("cexo255@163.com")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("http://www.relaxlife.net")]
#if NETCLIENT
[assembly: AssemblyProduct("Pub.Class.NetClient")]
#else
[assembly: AssemblyProduct("Pub.Class.Net")]
#endif
[assembly: AssemblyCopyright("Copyright ©http://www.relaxlife.net  2006")]
[assembly: AssemblyTrademark("LiveXY")]
[assembly: AssemblyCulture("")]

// 将 ComVisible 设置为 false 使此程序集中的类型
// 对 COM 组件不可见。如果需要从 COM 访问此程序集中的类型，
// 则将该类型上的 ComVisible 属性设置为 true。
[assembly: ComVisible(false)]

// 如果此项目向 COM 公开，则下列 GUID 用于类型库的 ID
#if !MONO
[assembly: Guid("2a2822e6-34ca-4b74-bc8c-e03f88c62194")]
#endif
// 程序集的版本信息由下面四个值组成:
//
//      主版本
//      次版本 
//      内部版本号
//      修订号
//
// 可以指定所有这些值，也可以使用“修订号”和“内部版本号”的默认值，
// 方法是按如下所示使用“*”:
[assembly: AssemblyVersion("2.7.1")]
[assembly: AssemblyFileVersion("2.7.1")]
