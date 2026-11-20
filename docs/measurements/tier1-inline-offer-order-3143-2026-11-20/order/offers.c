#include <stdio.h>
typedef unsigned (*fn)(unsigned);
extern unsigned replaceable(unsigned) __attribute__((weak));
__attribute__((weak)) unsigned replaceable(unsigned x){return x^739u;}
static inline __attribute__((always_inline)) unsigned f0(unsigned x){return x*1u+11u;}
static inline __attribute__((always_inline)) unsigned f1(unsigned x){return x*3u+14u;}
static inline __attribute__((always_inline)) unsigned f2(unsigned x){return x*5u+17u;}
static inline __attribute__((always_inline)) unsigned f3(unsigned x){return x*7u+20u;}
static inline __attribute__((always_inline)) unsigned f4(unsigned x){return x*9u+23u;}
static inline __attribute__((always_inline)) unsigned f5(unsigned x){return x*11u+26u;}
static inline __attribute__((always_inline)) unsigned f6(unsigned x){return x*13u+29u;}
static inline __attribute__((always_inline)) unsigned f7(unsigned x){return x*15u+32u;}
static inline __attribute__((always_inline)) unsigned f8(unsigned x){return x*17u+35u;}
static inline __attribute__((always_inline)) unsigned f9(unsigned x){return x*19u+38u;}
static inline __attribute__((always_inline)) unsigned f10(unsigned x){return x*21u+41u;}
static inline __attribute__((always_inline)) unsigned f11(unsigned x){return x*23u+44u;}
static inline __attribute__((always_inline)) unsigned f12(unsigned x){return x*25u+47u;}
static inline __attribute__((always_inline)) unsigned f13(unsigned x){return x*27u+50u;}
static inline __attribute__((always_inline)) unsigned f14(unsigned x){return x*29u+53u;}
static inline __attribute__((always_inline)) unsigned f15(unsigned x){return x*31u+56u;}
static inline __attribute__((always_inline)) unsigned f16(unsigned x){return x*33u+59u;}
static inline __attribute__((always_inline)) unsigned f17(unsigned x){return x*35u+62u;}
static inline __attribute__((always_inline)) unsigned f18(unsigned x){return x*37u+65u;}
static inline __attribute__((always_inline)) unsigned f19(unsigned x){return x*39u+68u;}
static inline __attribute__((always_inline)) unsigned f20(unsigned x){return x*41u+71u;}
static inline __attribute__((always_inline)) unsigned f21(unsigned x){return x*43u+74u;}
static inline __attribute__((always_inline)) unsigned f22(unsigned x){return x*45u+77u;}
static inline __attribute__((always_inline)) unsigned f23(unsigned x){return x*47u+80u;}
static inline __attribute__((always_inline)) unsigned f24(unsigned x){return x*49u+83u;}
static inline __attribute__((always_inline)) unsigned f25(unsigned x){return x*51u+86u;}
static inline __attribute__((always_inline)) unsigned f26(unsigned x){return x*53u+89u;}
static inline __attribute__((always_inline)) unsigned f27(unsigned x){return x*55u+92u;}
static inline __attribute__((always_inline)) unsigned f28(unsigned x){return x*57u+95u;}
static inline __attribute__((always_inline)) unsigned f29(unsigned x){return x*59u+98u;}
static inline __attribute__((always_inline)) unsigned f30(unsigned x){return x*61u+101u;}
static inline __attribute__((always_inline)) unsigned f31(unsigned x){return x*63u+104u;}
static inline __attribute__((always_inline)) unsigned f32(unsigned x){return x*65u+107u;}
static inline __attribute__((always_inline)) unsigned f33(unsigned x){return x*67u+110u;}
static inline __attribute__((always_inline)) unsigned f34(unsigned x){return x*69u+113u;}
static inline __attribute__((always_inline)) unsigned f35(unsigned x){return x*71u+116u;}
static inline __attribute__((always_inline)) unsigned f36(unsigned x){return x*73u+119u;}
static inline __attribute__((always_inline)) unsigned f37(unsigned x){return x*75u+122u;}
static inline __attribute__((always_inline)) unsigned f38(unsigned x){return x*77u+125u;}
static inline __attribute__((always_inline)) unsigned f39(unsigned x){return x*79u+128u;}
static inline __attribute__((always_inline)) unsigned f40(unsigned x){return x*81u+131u;}
static inline __attribute__((always_inline)) unsigned f41(unsigned x){return x*83u+134u;}
static inline __attribute__((always_inline)) unsigned f42(unsigned x){return x*85u+137u;}
static inline __attribute__((always_inline)) unsigned f43(unsigned x){return x*87u+140u;}
static inline __attribute__((always_inline)) unsigned f44(unsigned x){return x*89u+143u;}
static inline __attribute__((always_inline)) unsigned f45(unsigned x){return x*91u+146u;}
static inline __attribute__((always_inline)) unsigned f46(unsigned x){return x*93u+149u;}
static inline __attribute__((always_inline)) unsigned f47(unsigned x){return x*95u+152u;}
static inline __attribute__((always_inline)) unsigned f48(unsigned x){return x*97u+155u;}
static inline __attribute__((always_inline)) unsigned f49(unsigned x){return x*99u+158u;}
static inline __attribute__((always_inline)) unsigned f50(unsigned x){return x*101u+161u;}
static inline __attribute__((always_inline)) unsigned f51(unsigned x){return x*103u+164u;}
static inline __attribute__((always_inline)) unsigned f52(unsigned x){return x*105u+167u;}
static inline __attribute__((always_inline)) unsigned f53(unsigned x){return x*107u+170u;}
static inline __attribute__((always_inline)) unsigned f54(unsigned x){return x*109u+173u;}
static inline __attribute__((always_inline)) unsigned f55(unsigned x){return x*111u+176u;}
static inline __attribute__((always_inline)) unsigned f56(unsigned x){return x*113u+179u;}
static inline __attribute__((always_inline)) unsigned f57(unsigned x){return x*115u+182u;}
static inline __attribute__((always_inline)) unsigned f58(unsigned x){return x*117u+185u;}
static inline __attribute__((always_inline)) unsigned f59(unsigned x){return x*119u+188u;}
static inline __attribute__((always_inline)) unsigned f60(unsigned x){return x*121u+191u;}
static inline __attribute__((always_inline)) unsigned f61(unsigned x){return x*123u+194u;}
static inline __attribute__((always_inline)) unsigned f62(unsigned x){return x*125u+197u;}
static inline __attribute__((always_inline)) unsigned f63(unsigned x){return x*127u+200u;}
static inline __attribute__((always_inline)) unsigned f64(unsigned x){return x*129u+203u;}
static inline __attribute__((always_inline)) unsigned f65(unsigned x){return x*131u+206u;}
static inline __attribute__((always_inline)) unsigned f66(unsigned x){return x*133u+209u;}
static inline __attribute__((always_inline)) unsigned f67(unsigned x){return x*135u+212u;}
static inline __attribute__((always_inline)) unsigned f68(unsigned x){return x*137u+215u;}
static inline __attribute__((always_inline)) unsigned f69(unsigned x){return x*139u+218u;}
static inline __attribute__((always_inline)) unsigned f70(unsigned x){return x*141u+221u;}
static inline __attribute__((always_inline)) unsigned f71(unsigned x){return x*143u+224u;}
static inline __attribute__((always_inline)) unsigned f72(unsigned x){return x*145u+227u;}
static inline __attribute__((always_inline)) unsigned f73(unsigned x){return x*147u+230u;}
static inline __attribute__((always_inline)) unsigned f74(unsigned x){return x*149u+233u;}
static inline __attribute__((always_inline)) unsigned f75(unsigned x){return x*151u+236u;}
static inline __attribute__((always_inline)) unsigned f76(unsigned x){return x*153u+239u;}
static inline __attribute__((always_inline)) unsigned f77(unsigned x){return x*155u+242u;}
static inline __attribute__((always_inline)) unsigned f78(unsigned x){return x*157u+245u;}
static inline __attribute__((always_inline)) unsigned f79(unsigned x){return x*159u+248u;}
static inline __attribute__((always_inline)) unsigned f80(unsigned x){return x*161u+251u;}
static inline __attribute__((always_inline)) unsigned f81(unsigned x){return x*163u+254u;}
static inline __attribute__((always_inline)) unsigned f82(unsigned x){return x*165u+257u;}
static inline __attribute__((always_inline)) unsigned f83(unsigned x){return x*167u+260u;}
static inline __attribute__((always_inline)) unsigned f84(unsigned x){return x*169u+263u;}
static inline __attribute__((always_inline)) unsigned f85(unsigned x){return x*171u+266u;}
static inline __attribute__((always_inline)) unsigned f86(unsigned x){return x*173u+269u;}
static inline __attribute__((always_inline)) unsigned f87(unsigned x){return x*175u+272u;}
static inline __attribute__((always_inline)) unsigned f88(unsigned x){return x*177u+275u;}
static inline __attribute__((always_inline)) unsigned f89(unsigned x){return x*179u+278u;}
static inline __attribute__((always_inline)) unsigned f90(unsigned x){return x*181u+281u;}
static inline __attribute__((always_inline)) unsigned f91(unsigned x){return x*183u+284u;}
static inline __attribute__((always_inline)) unsigned f92(unsigned x){return x*185u+287u;}
static inline __attribute__((always_inline)) unsigned f93(unsigned x){return x*187u+290u;}
static inline __attribute__((always_inline)) unsigned f94(unsigned x){return x*189u+293u;}
static inline __attribute__((always_inline)) unsigned f95(unsigned x){return x*191u+296u;}
static inline __attribute__((always_inline)) unsigned f96(unsigned x){return x*193u+299u;}
static inline __attribute__((always_inline)) unsigned f97(unsigned x){return x*195u+302u;}
static inline __attribute__((always_inline)) unsigned f98(unsigned x){return x*197u+305u;}
static inline __attribute__((always_inline)) unsigned f99(unsigned x){return x*199u+308u;}
static inline __attribute__((always_inline)) unsigned f100(unsigned x){return x*201u+311u;}
static inline __attribute__((always_inline)) unsigned f101(unsigned x){return x*203u+314u;}
static inline __attribute__((always_inline)) unsigned f102(unsigned x){return x*205u+317u;}
static inline __attribute__((always_inline)) unsigned f103(unsigned x){return x*207u+320u;}
static inline __attribute__((always_inline)) unsigned f104(unsigned x){return x*209u+323u;}
static inline __attribute__((always_inline)) unsigned f105(unsigned x){return x*211u+326u;}
static inline __attribute__((always_inline)) unsigned f106(unsigned x){return x*213u+329u;}
static inline __attribute__((always_inline)) unsigned f107(unsigned x){return x*215u+332u;}
static inline __attribute__((always_inline)) unsigned f108(unsigned x){return x*217u+335u;}
static inline __attribute__((always_inline)) unsigned f109(unsigned x){return x*219u+338u;}
static inline __attribute__((always_inline)) unsigned f110(unsigned x){return x*221u+341u;}
static inline __attribute__((always_inline)) unsigned f111(unsigned x){return x*223u+344u;}
static inline __attribute__((always_inline)) unsigned f112(unsigned x){return x*225u+347u;}
static inline __attribute__((always_inline)) unsigned f113(unsigned x){return x*227u+350u;}
static inline __attribute__((always_inline)) unsigned f114(unsigned x){return x*229u+353u;}
static inline __attribute__((always_inline)) unsigned f115(unsigned x){return x*231u+356u;}
static inline __attribute__((always_inline)) unsigned f116(unsigned x){return x*233u+359u;}
static inline __attribute__((always_inline)) unsigned f117(unsigned x){return x*235u+362u;}
static inline __attribute__((always_inline)) unsigned f118(unsigned x){return x*237u+365u;}
static inline __attribute__((always_inline)) unsigned f119(unsigned x){return x*239u+368u;}
static inline __attribute__((always_inline)) unsigned f120(unsigned x){return x*241u+371u;}
static inline __attribute__((always_inline)) unsigned f121(unsigned x){return x*243u+374u;}
static inline __attribute__((always_inline)) unsigned f122(unsigned x){return x*245u+377u;}
static inline __attribute__((always_inline)) unsigned f123(unsigned x){return x*247u+380u;}
static inline __attribute__((always_inline)) unsigned f124(unsigned x){return x*249u+383u;}
static inline __attribute__((always_inline)) unsigned f125(unsigned x){return x*251u+386u;}
static inline __attribute__((always_inline)) unsigned f126(unsigned x){return x*253u+389u;}
static inline __attribute__((always_inline)) unsigned f127(unsigned x){return x*255u+392u;}
static inline __attribute__((always_inline)) unsigned f128(unsigned x){return x*257u+395u;}
static inline __attribute__((always_inline)) unsigned f129(unsigned x){return x*259u+398u;}
static inline __attribute__((always_inline)) unsigned f130(unsigned x){return x*261u+401u;}
static inline __attribute__((always_inline)) unsigned f131(unsigned x){return x*263u+404u;}
static inline __attribute__((always_inline)) unsigned f132(unsigned x){return x*265u+407u;}
static inline __attribute__((always_inline)) unsigned f133(unsigned x){return x*267u+410u;}
static inline __attribute__((always_inline)) unsigned f134(unsigned x){return x*269u+413u;}
static inline __attribute__((always_inline)) unsigned f135(unsigned x){return x*271u+416u;}
static inline __attribute__((always_inline)) unsigned f136(unsigned x){return x*273u+419u;}
static inline __attribute__((always_inline)) unsigned f137(unsigned x){return x*275u+422u;}
static inline __attribute__((always_inline)) unsigned f138(unsigned x){return x*277u+425u;}
static inline __attribute__((always_inline)) unsigned f139(unsigned x){return x*279u+428u;}
static inline __attribute__((always_inline)) unsigned f140(unsigned x){return x*281u+431u;}
static inline __attribute__((always_inline)) unsigned f141(unsigned x){return x*283u+434u;}
static inline __attribute__((always_inline)) unsigned f142(unsigned x){return x*285u+437u;}
static inline __attribute__((always_inline)) unsigned f143(unsigned x){return x*287u+440u;}
static inline __attribute__((always_inline)) unsigned f144(unsigned x){return x*289u+443u;}
static inline __attribute__((always_inline)) unsigned f145(unsigned x){return x*291u+446u;}
static inline __attribute__((always_inline)) unsigned f146(unsigned x){return x*293u+449u;}
static inline __attribute__((always_inline)) unsigned f147(unsigned x){return x*295u+452u;}
static inline __attribute__((always_inline)) unsigned f148(unsigned x){return x*297u+455u;}
static inline __attribute__((always_inline)) unsigned f149(unsigned x){return x*299u+458u;}
static inline __attribute__((always_inline)) unsigned f150(unsigned x){return x*301u+461u;}
static inline __attribute__((always_inline)) unsigned f151(unsigned x){return x*303u+464u;}
static inline __attribute__((always_inline)) unsigned f152(unsigned x){return x*305u+467u;}
static inline __attribute__((always_inline)) unsigned f153(unsigned x){return x*307u+470u;}
static inline __attribute__((always_inline)) unsigned f154(unsigned x){return x*309u+473u;}
static inline __attribute__((always_inline)) unsigned f155(unsigned x){return x*311u+476u;}
static inline __attribute__((always_inline)) unsigned f156(unsigned x){return x*313u+479u;}
static inline __attribute__((always_inline)) unsigned f157(unsigned x){return x*315u+482u;}
static inline __attribute__((always_inline)) unsigned f158(unsigned x){return x*317u+485u;}
static inline __attribute__((always_inline)) unsigned f159(unsigned x){return x*319u+488u;}
static inline __attribute__((always_inline)) unsigned f160(unsigned x){return x*321u+491u;}
static inline __attribute__((always_inline)) unsigned f161(unsigned x){return x*323u+494u;}
static inline __attribute__((always_inline)) unsigned f162(unsigned x){return x*325u+497u;}
static inline __attribute__((always_inline)) unsigned f163(unsigned x){return x*327u+500u;}
static inline __attribute__((always_inline)) unsigned f164(unsigned x){return x*329u+503u;}
static inline __attribute__((always_inline)) unsigned f165(unsigned x){return x*331u+506u;}
static inline __attribute__((always_inline)) unsigned f166(unsigned x){return x*333u+509u;}
static inline __attribute__((always_inline)) unsigned f167(unsigned x){return x*335u+512u;}
static inline __attribute__((always_inline)) unsigned f168(unsigned x){return x*337u+515u;}
static inline __attribute__((always_inline)) unsigned f169(unsigned x){return x*339u+518u;}
static inline __attribute__((always_inline)) unsigned f170(unsigned x){return x*341u+521u;}
static inline __attribute__((always_inline)) unsigned f171(unsigned x){return x*343u+524u;}
static inline __attribute__((always_inline)) unsigned f172(unsigned x){return x*345u+527u;}
static inline __attribute__((always_inline)) unsigned f173(unsigned x){return x*347u+530u;}
static inline __attribute__((always_inline)) unsigned f174(unsigned x){return x*349u+533u;}
static inline __attribute__((always_inline)) unsigned f175(unsigned x){return x*351u+536u;}
static inline __attribute__((always_inline)) unsigned f176(unsigned x){return x*353u+539u;}
static inline __attribute__((always_inline)) unsigned f177(unsigned x){return x*355u+542u;}
static inline __attribute__((always_inline)) unsigned f178(unsigned x){return x*357u+545u;}
static inline __attribute__((always_inline)) unsigned f179(unsigned x){return x*359u+548u;}
static inline __attribute__((always_inline)) unsigned f180(unsigned x){return x*361u+551u;}
static inline __attribute__((always_inline)) unsigned f181(unsigned x){return x*363u+554u;}
static inline __attribute__((always_inline)) unsigned f182(unsigned x){return x*365u+557u;}
static inline __attribute__((always_inline)) unsigned f183(unsigned x){return x*367u+560u;}
static inline __attribute__((always_inline)) unsigned f184(unsigned x){return x*369u+563u;}
static inline __attribute__((always_inline)) unsigned f185(unsigned x){return x*371u+566u;}
static inline __attribute__((always_inline)) unsigned f186(unsigned x){return x*373u+569u;}
static inline __attribute__((always_inline)) unsigned f187(unsigned x){return x*375u+572u;}
static inline __attribute__((always_inline)) unsigned f188(unsigned x){return x*377u+575u;}
static inline __attribute__((always_inline)) unsigned f189(unsigned x){return x*379u+578u;}
static inline __attribute__((always_inline)) unsigned f190(unsigned x){return x*381u+581u;}
static inline __attribute__((always_inline)) unsigned f191(unsigned x){return x*383u+584u;}
static inline __attribute__((always_inline)) unsigned f192(unsigned x){return x*385u+587u;}
static inline __attribute__((always_inline)) unsigned f193(unsigned x){return x*387u+590u;}
static inline __attribute__((always_inline)) unsigned f194(unsigned x){return x*389u+593u;}
static inline __attribute__((always_inline)) unsigned f195(unsigned x){return x*391u+596u;}
static inline __attribute__((always_inline)) unsigned f196(unsigned x){return x*393u+599u;}
static inline __attribute__((always_inline)) unsigned f197(unsigned x){return x*395u+602u;}
static inline __attribute__((always_inline)) unsigned f198(unsigned x){return x*397u+605u;}
static inline __attribute__((always_inline)) unsigned f199(unsigned x){return x*399u+608u;}
static inline __attribute__((always_inline)) unsigned f200(unsigned x){return x*401u+611u;}
static inline __attribute__((always_inline)) unsigned f201(unsigned x){return x*403u+614u;}
static inline __attribute__((always_inline)) unsigned f202(unsigned x){return x*405u+617u;}
static inline __attribute__((always_inline)) unsigned f203(unsigned x){return x*407u+620u;}
static inline __attribute__((always_inline)) unsigned f204(unsigned x){return x*409u+623u;}
static inline __attribute__((always_inline)) unsigned f205(unsigned x){return x*411u+626u;}
static inline __attribute__((always_inline)) unsigned f206(unsigned x){return x*413u+629u;}
static inline __attribute__((always_inline)) unsigned f207(unsigned x){return x*415u+632u;}
static inline __attribute__((always_inline)) unsigned f208(unsigned x){return x*417u+635u;}
static inline __attribute__((always_inline)) unsigned f209(unsigned x){return x*419u+638u;}
static inline __attribute__((always_inline)) unsigned f210(unsigned x){return x*421u+641u;}
static inline __attribute__((always_inline)) unsigned f211(unsigned x){return x*423u+644u;}
static inline __attribute__((always_inline)) unsigned f212(unsigned x){return x*425u+647u;}
static inline __attribute__((always_inline)) unsigned f213(unsigned x){return x*427u+650u;}
static inline __attribute__((always_inline)) unsigned f214(unsigned x){return x*429u+653u;}
static inline __attribute__((always_inline)) unsigned f215(unsigned x){return x*431u+656u;}
static inline __attribute__((always_inline)) unsigned f216(unsigned x){return x*433u+659u;}
static inline __attribute__((always_inline)) unsigned f217(unsigned x){return x*435u+662u;}
static inline __attribute__((always_inline)) unsigned f218(unsigned x){return x*437u+665u;}
static inline __attribute__((always_inline)) unsigned f219(unsigned x){return x*439u+668u;}
static inline __attribute__((always_inline)) unsigned f220(unsigned x){return x*441u+671u;}
static inline __attribute__((always_inline)) unsigned f221(unsigned x){return x*443u+674u;}
static inline __attribute__((always_inline)) unsigned f222(unsigned x){return x*445u+677u;}
static inline __attribute__((always_inline)) unsigned f223(unsigned x){return x*447u+680u;}
static inline __attribute__((always_inline)) unsigned f224(unsigned x){return x*449u+683u;}
static inline __attribute__((always_inline)) unsigned f225(unsigned x){return x*451u+686u;}
static inline __attribute__((always_inline)) unsigned f226(unsigned x){return x*453u+689u;}
static inline __attribute__((always_inline)) unsigned f227(unsigned x){return x*455u+692u;}
static inline __attribute__((always_inline)) unsigned f228(unsigned x){return x*457u+695u;}
static inline __attribute__((always_inline)) unsigned f229(unsigned x){return x*459u+698u;}
static inline __attribute__((always_inline)) unsigned f230(unsigned x){return x*461u+701u;}
static inline __attribute__((always_inline)) unsigned f231(unsigned x){return x*463u+704u;}
static inline __attribute__((always_inline)) unsigned f232(unsigned x){return x*465u+707u;}
static inline __attribute__((always_inline)) unsigned f233(unsigned x){return x*467u+710u;}
static inline __attribute__((always_inline)) unsigned f234(unsigned x){return x*469u+713u;}
static inline __attribute__((always_inline)) unsigned f235(unsigned x){return x*471u+716u;}
static inline __attribute__((always_inline)) unsigned f236(unsigned x){return x*473u+719u;}
static inline __attribute__((always_inline)) unsigned f237(unsigned x){return x*475u+722u;}
static inline __attribute__((always_inline)) unsigned f238(unsigned x){return x*477u+725u;}
static inline __attribute__((always_inline)) unsigned f239(unsigned x){return x*479u+728u;}
static inline __attribute__((always_inline)) unsigned f240(unsigned x){return x*481u+731u;}
static inline __attribute__((always_inline)) unsigned f241(unsigned x){return x*483u+734u;}
static inline __attribute__((always_inline)) unsigned f242(unsigned x){return x*485u+737u;}
static inline __attribute__((always_inline)) unsigned f243(unsigned x){return x*487u+740u;}
static inline __attribute__((always_inline)) unsigned f244(unsigned x){return x*489u+743u;}
static inline __attribute__((always_inline)) unsigned f245(unsigned x){return x*491u+746u;}
static inline __attribute__((always_inline)) unsigned f246(unsigned x){return x*493u+749u;}
static inline __attribute__((always_inline)) unsigned f247(unsigned x){return x*495u+752u;}
static inline __attribute__((always_inline)) unsigned f248(unsigned x){return x*497u+755u;}
static inline __attribute__((always_inline)) unsigned f249(unsigned x){return x*499u+758u;}
static inline __attribute__((always_inline)) unsigned f250(unsigned x){return x*501u+761u;}
static inline __attribute__((always_inline)) unsigned f251(unsigned x){return x*503u+764u;}
static inline __attribute__((always_inline)) unsigned f252(unsigned x){return x*505u+767u;}
static inline __attribute__((always_inline)) unsigned f253(unsigned x){return x*507u+770u;}
static inline __attribute__((always_inline)) unsigned f254(unsigned x){return x*509u+773u;}
static inline __attribute__((always_inline)) unsigned f255(unsigned x){return x*511u+776u;}
static inline __attribute__((always_inline)) unsigned f256(unsigned x){return x*513u+779u;}
static inline __attribute__((always_inline)) unsigned f257(unsigned x){return x*515u+782u;}
static inline __attribute__((always_inline)) unsigned f258(unsigned x){return x*517u+785u;}
static inline __attribute__((always_inline)) unsigned f259(unsigned x){return x*519u+788u;}
static inline __attribute__((always_inline)) unsigned f260(unsigned x){return x*521u+791u;}
static inline __attribute__((always_inline)) unsigned f261(unsigned x){return x*523u+794u;}
static inline __attribute__((always_inline)) unsigned f262(unsigned x){return x*525u+797u;}
static inline __attribute__((always_inline)) unsigned f263(unsigned x){return x*527u+800u;}
static inline __attribute__((always_inline)) unsigned f264(unsigned x){return x*529u+803u;}
static inline __attribute__((always_inline)) unsigned f265(unsigned x){return x*531u+806u;}
static inline __attribute__((always_inline)) unsigned f266(unsigned x){return x*533u+809u;}
static inline __attribute__((always_inline)) unsigned f267(unsigned x){return x*535u+812u;}
static inline __attribute__((always_inline)) unsigned f268(unsigned x){return x*537u+815u;}
static inline __attribute__((always_inline)) unsigned f269(unsigned x){return x*539u+818u;}
static inline __attribute__((always_inline)) unsigned f270(unsigned x){return x*541u+821u;}
static inline __attribute__((always_inline)) unsigned f271(unsigned x){return x*543u+824u;}
static inline __attribute__((always_inline)) unsigned f272(unsigned x){return x*545u+827u;}
static inline __attribute__((always_inline)) unsigned f273(unsigned x){return x*547u+830u;}
static inline __attribute__((always_inline)) unsigned f274(unsigned x){return x*549u+833u;}
static inline __attribute__((always_inline)) unsigned f275(unsigned x){return x*551u+836u;}
static inline __attribute__((always_inline)) unsigned f276(unsigned x){return x*553u+839u;}
static inline __attribute__((always_inline)) unsigned f277(unsigned x){return x*555u+842u;}
static inline __attribute__((always_inline)) unsigned f278(unsigned x){return x*557u+845u;}
static inline __attribute__((always_inline)) unsigned f279(unsigned x){return x*559u+848u;}
static inline __attribute__((always_inline)) unsigned f280(unsigned x){return x*561u+851u;}
static inline __attribute__((always_inline)) unsigned f281(unsigned x){return x*563u+854u;}
static inline __attribute__((always_inline)) unsigned f282(unsigned x){return x*565u+857u;}
static inline __attribute__((always_inline)) unsigned f283(unsigned x){return x*567u+860u;}
static inline __attribute__((always_inline)) unsigned f284(unsigned x){return x*569u+863u;}
static inline __attribute__((always_inline)) unsigned f285(unsigned x){return x*571u+866u;}
static inline __attribute__((always_inline)) unsigned f286(unsigned x){return x*573u+869u;}
static inline __attribute__((always_inline)) unsigned f287(unsigned x){return x*575u+872u;}
static inline __attribute__((always_inline)) unsigned f288(unsigned x){return x*577u+875u;}
static inline __attribute__((always_inline)) unsigned f289(unsigned x){return x*579u+878u;}
__attribute__((noinline)) unsigned no_calls(unsigned x){return (x+17u)^493u;}
__attribute__((noinline)) unsigned indirect(fn p,unsigned x){return p(x);}
__attribute__((noinline)) unsigned order0(unsigned x){
x = f0(x);
x = f1(x);
x = f2(x);
x = f3(x);
x = f4(x);
x = f5(x);
x = f6(x);
x = f7(x);
x = f8(x);
x = f9(x);
x = f10(x);
x = f11(x);
x = f12(x);
x = f13(x);
x = f14(x);
x = f15(x);
x = f16(x);
x = f17(x);
x = f18(x);
x = f19(x);
x = f20(x);
x = f21(x);
x = f22(x);
x = f23(x);
x = f24(x);
x = f25(x);
x = f26(x);
x = f27(x);
x = f28(x);
x = f29(x);
x = f30(x);
x = f31(x);
x = f32(x);
x = f33(x);
x = f34(x);
x = f35(x);
x = f36(x);
x = f37(x);
x = f38(x);
x = f39(x);
x = f40(x);
x = f41(x);
x = f42(x);
x = f43(x);
x = f44(x);
x = f45(x);
x = f46(x);
x = f47(x);
x = f48(x);
x = f49(x);
x = f50(x);
x = f51(x);
x = f52(x);
x = f53(x);
x = f54(x);
x = f55(x);
x = f56(x);
x = f57(x);
x = f58(x);
x = f59(x);
x = f60(x);
x = f61(x);
x = f62(x);
x = f63(x);
x = f64(x);
x = f65(x);
x = f66(x);
x = f67(x);
x = f68(x);
x = f69(x);
x = f70(x);
x = f71(x);
x = f72(x);
x = f73(x);
x = f74(x);
x = f75(x);
x = f76(x);
x = f77(x);
x = f78(x);
x = f79(x);
x = f80(x);
x = f81(x);
x = f82(x);
x = f83(x);
x = f84(x);
x = f85(x);
x = f86(x);
x = f87(x);
x = f88(x);
x = f89(x);
x = f90(x);
x = f91(x);
x = f92(x);
x = f93(x);
x = f94(x);
x = f95(x);
x = f96(x);
x = f97(x);
x = f98(x);
x = f99(x);
x = f100(x);
x = f101(x);
x = f102(x);
x = f103(x);
x = f104(x);
x = f105(x);
x = f106(x);
x = f107(x);
x = f108(x);
x = f109(x);
x = f110(x);
x = f111(x);
x = f112(x);
x = f113(x);
x = f114(x);
x = f115(x);
x = f116(x);
x = f117(x);
x = f118(x);
x = f119(x);
x = f120(x);
x = f121(x);
x = f122(x);
x = f123(x);
x = f124(x);
x = f125(x);
x = f126(x);
x = f127(x);
x = f128(x);
x = f129(x);
x = f130(x);
x = f131(x);
x = f132(x);
x = f133(x);
x = f134(x);
x = f135(x);
x = f136(x);
x = f137(x);
x = f138(x);
x = f139(x);
x = f140(x);
x = f141(x);
x = f142(x);
x = f143(x);
x = f144(x);
x = f145(x);
x = f146(x);
x = f147(x);
x = f148(x);
x = f149(x);
x = f150(x);
x = f151(x);
x = f152(x);
x = f153(x);
x = f154(x);
x = f155(x);
x = f156(x);
x = f157(x);
x = f158(x);
x = f159(x);
x = f160(x);
x = f161(x);
x = f162(x);
x = f163(x);
x = f164(x);
x = f165(x);
x = f166(x);
x = f167(x);
x = f168(x);
x = f169(x);
x = f170(x);
x = f171(x);
x = f172(x);
x = f173(x);
x = f174(x);
x = f175(x);
x = f176(x);
x = f177(x);
x = f178(x);
x = f179(x);
x = f180(x);
x = f181(x);
x = f182(x);
x = f183(x);
x = f184(x);
x = f185(x);
x = f186(x);
x = f187(x);
x = f188(x);
x = f189(x);
x = f190(x);
x = f191(x);
x = f192(x);
x = f193(x);
x = f194(x);
x = f195(x);
x = f196(x);
x = f197(x);
x = f198(x);
x = f199(x);
x = f200(x);
x = f201(x);
x = f202(x);
x = f203(x);
x = f204(x);
x = f205(x);
x = f206(x);
x = f207(x);
x = f208(x);
x = f209(x);
x = f210(x);
x = f211(x);
x = f212(x);
x = f213(x);
x = f214(x);
x = f215(x);
x = f216(x);
x = f217(x);
x = f218(x);
x = f219(x);
x = f220(x);
x = f221(x);
x = f222(x);
x = f223(x);
x = f224(x);
x = f225(x);
x = f226(x);
x = f227(x);
x = f228(x);
x = f229(x);
x = f230(x);
x = f231(x);
x = f232(x);
x = f233(x);
x = f234(x);
x = f235(x);
x = f236(x);
x = f237(x);
x = f238(x);
x = f239(x);
x = f240(x);
x = f241(x);
x = f242(x);
x = f243(x);
x = f244(x);
x = f245(x);
x = f246(x);
x = f247(x);
x = f248(x);
x = f249(x);
x = f250(x);
x = f251(x);
x = f252(x);
x = f253(x);
x = f254(x);
x = f255(x);
x = f256(x);
x = f257(x);
x = f258(x);
x = f259(x);
x = f260(x);
x = f261(x);
x = f262(x);
x = f263(x);
x = f264(x);
x = f265(x);
x = f266(x);
x = f267(x);
x = f268(x);
x = f269(x);
x = f270(x);
x = f271(x);
x = f272(x);
x = f273(x);
x = f274(x);
x = f275(x);
x = f276(x);
x = f277(x);
x = f278(x);
x = f279(x);
x = f280(x);
x = f281(x);
x = f282(x);
x = f283(x);
x = f284(x);
x = f285(x);
x = f286(x);
x = f287(x);
x = f288(x);
x = f289(x);
return x;}
__attribute__((noinline)) unsigned order1(unsigned x){
x = f289(x);
x = f288(x);
x = f287(x);
x = f286(x);
x = f285(x);
x = f284(x);
x = f283(x);
x = f282(x);
x = f281(x);
x = f280(x);
x = f279(x);
x = f278(x);
x = f277(x);
x = f276(x);
x = f275(x);
x = f274(x);
x = f273(x);
x = f272(x);
x = f271(x);
x = f270(x);
x = f269(x);
x = f268(x);
x = f267(x);
x = f266(x);
x = f265(x);
x = f264(x);
x = f263(x);
x = f262(x);
x = f261(x);
x = f260(x);
x = f259(x);
x = f258(x);
x = f257(x);
x = f256(x);
x = f255(x);
x = f254(x);
x = f253(x);
x = f252(x);
x = f251(x);
x = f250(x);
x = f249(x);
x = f248(x);
x = f247(x);
x = f246(x);
x = f245(x);
x = f244(x);
x = f243(x);
x = f242(x);
x = f241(x);
x = f240(x);
x = f239(x);
x = f238(x);
x = f237(x);
x = f236(x);
x = f235(x);
x = f234(x);
x = f233(x);
x = f232(x);
x = f231(x);
x = f230(x);
x = f229(x);
x = f228(x);
x = f227(x);
x = f226(x);
x = f225(x);
x = f224(x);
x = f223(x);
x = f222(x);
x = f221(x);
x = f220(x);
x = f219(x);
x = f218(x);
x = f217(x);
x = f216(x);
x = f215(x);
x = f214(x);
x = f213(x);
x = f212(x);
x = f211(x);
x = f210(x);
x = f209(x);
x = f208(x);
x = f207(x);
x = f206(x);
x = f205(x);
x = f204(x);
x = f203(x);
x = f202(x);
x = f201(x);
x = f200(x);
x = f199(x);
x = f198(x);
x = f197(x);
x = f196(x);
x = f195(x);
x = f194(x);
x = f193(x);
x = f192(x);
x = f191(x);
x = f190(x);
x = f189(x);
x = f188(x);
x = f187(x);
x = f186(x);
x = f185(x);
x = f184(x);
x = f183(x);
x = f182(x);
x = f181(x);
x = f180(x);
x = f179(x);
x = f178(x);
x = f177(x);
x = f176(x);
x = f175(x);
x = f174(x);
x = f173(x);
x = f172(x);
x = f171(x);
x = f170(x);
x = f169(x);
x = f168(x);
x = f167(x);
x = f166(x);
x = f165(x);
x = f164(x);
x = f163(x);
x = f162(x);
x = f161(x);
x = f160(x);
x = f159(x);
x = f158(x);
x = f157(x);
x = f156(x);
x = f155(x);
x = f154(x);
x = f153(x);
x = f152(x);
x = f151(x);
x = f150(x);
x = f149(x);
x = f148(x);
x = f147(x);
x = f146(x);
x = f145(x);
x = f144(x);
x = f143(x);
x = f142(x);
x = f141(x);
x = f140(x);
x = f139(x);
x = f138(x);
x = f137(x);
x = f136(x);
x = f135(x);
x = f134(x);
x = f133(x);
x = f132(x);
x = f131(x);
x = f130(x);
x = f129(x);
x = f128(x);
x = f127(x);
x = f126(x);
x = f125(x);
x = f124(x);
x = f123(x);
x = f122(x);
x = f121(x);
x = f120(x);
x = f119(x);
x = f118(x);
x = f117(x);
x = f116(x);
x = f115(x);
x = f114(x);
x = f113(x);
x = f112(x);
x = f111(x);
x = f110(x);
x = f109(x);
x = f108(x);
x = f107(x);
x = f106(x);
x = f105(x);
x = f104(x);
x = f103(x);
x = f102(x);
x = f101(x);
x = f100(x);
x = f99(x);
x = f98(x);
x = f97(x);
x = f96(x);
x = f95(x);
x = f94(x);
x = f93(x);
x = f92(x);
x = f91(x);
x = f90(x);
x = f89(x);
x = f88(x);
x = f87(x);
x = f86(x);
x = f85(x);
x = f84(x);
x = f83(x);
x = f82(x);
x = f81(x);
x = f80(x);
x = f79(x);
x = f78(x);
x = f77(x);
x = f76(x);
x = f75(x);
x = f74(x);
x = f73(x);
x = f72(x);
x = f71(x);
x = f70(x);
x = f69(x);
x = f68(x);
x = f67(x);
x = f66(x);
x = f65(x);
x = f64(x);
x = f63(x);
x = f62(x);
x = f61(x);
x = f60(x);
x = f59(x);
x = f58(x);
x = f57(x);
x = f56(x);
x = f55(x);
x = f54(x);
x = f53(x);
x = f52(x);
x = f51(x);
x = f50(x);
x = f49(x);
x = f48(x);
x = f47(x);
x = f46(x);
x = f45(x);
x = f44(x);
x = f43(x);
x = f42(x);
x = f41(x);
x = f40(x);
x = f39(x);
x = f38(x);
x = f37(x);
x = f36(x);
x = f35(x);
x = f34(x);
x = f33(x);
x = f32(x);
x = f31(x);
x = f30(x);
x = f29(x);
x = f28(x);
x = f27(x);
x = f26(x);
x = f25(x);
x = f24(x);
x = f23(x);
x = f22(x);
x = f21(x);
x = f20(x);
x = f19(x);
x = f18(x);
x = f17(x);
x = f16(x);
x = f15(x);
x = f14(x);
x = f13(x);
x = f12(x);
x = f11(x);
x = f10(x);
x = f9(x);
x = f8(x);
x = f7(x);
x = f6(x);
x = f5(x);
x = f4(x);
x = f3(x);
x = f2(x);
x = f1(x);
x = f0(x);
return x;}
__attribute__((noinline)) unsigned order2(unsigned x){
x = f130(x);
x = f32(x);
x = f9(x);
x = f25(x);
x = f131(x);
x = f200(x);
x = f285(x);
x = f271(x);
x = f47(x);
x = f184(x);
x = f66(x);
x = f15(x);
x = f71(x);
x = f133(x);
x = f94(x);
x = f23(x);
x = f228(x);
x = f20(x);
x = f250(x);
x = f93(x);
x = f186(x);
x = f212(x);
x = f276(x);
x = f196(x);
x = f225(x);
x = f229(x);
x = f99(x);
x = f166(x);
x = f19(x);
x = f199(x);
x = f119(x);
x = f193(x);
x = f223(x);
x = f13(x);
x = f175(x);
x = f275(x);
x = f109(x);
x = f43(x);
x = f159(x);
x = f280(x);
x = f115(x);
x = f270(x);
x = f254(x);
x = f203(x);
x = f54(x);
x = f242(x);
x = f168(x);
x = f173(x);
x = f120(x);
x = f61(x);
x = f255(x);
x = f222(x);
x = f55(x);
x = f78(x);
x = f56(x);
x = f6(x);
x = f98(x);
x = f146(x);
x = f16(x);
x = f95(x);
x = f33(x);
x = f252(x);
x = f118(x);
x = f287(x);
x = f232(x);
x = f91(x);
x = f170(x);
x = f65(x);
x = f213(x);
x = f74(x);
x = f108(x);
x = f245(x);
x = f3(x);
x = f201(x);
x = f174(x);
x = f126(x);
x = f97(x);
x = f207(x);
x = f70(x);
x = f235(x);
x = f141(x);
x = f247(x);
x = f187(x);
x = f227(x);
x = f249(x);
x = f209(x);
x = f112(x);
x = f215(x);
x = f114(x);
x = f128(x);
x = f77(x);
x = f125(x);
x = f34(x);
x = f144(x);
x = f52(x);
x = f150(x);
x = f102(x);
x = f183(x);
x = f162(x);
x = f217(x);
x = f231(x);
x = f220(x);
x = f10(x);
x = f35(x);
x = f5(x);
x = f46(x);
x = f29(x);
x = f40(x);
x = f260(x);
x = f218(x);
x = f234(x);
x = f274(x);
x = f216(x);
x = f121(x);
x = f69(x);
x = f0(x);
x = f68(x);
x = f269(x);
x = f41(x);
x = f62(x);
x = f75(x);
x = f288(x);
x = f149(x);
x = f257(x);
x = f169(x);
x = f22(x);
x = f116(x);
x = f197(x);
x = f48(x);
x = f273(x);
x = f72(x);
x = f194(x);
x = f190(x);
x = f268(x);
x = f156(x);
x = f205(x);
x = f14(x);
x = f167(x);
x = f237(x);
x = f105(x);
x = f134(x);
x = f17(x);
x = f281(x);
x = f122(x);
x = f178(x);
x = f57(x);
x = f129(x);
x = f31(x);
x = f283(x);
x = f244(x);
x = f256(x);
x = f113(x);
x = f157(x);
x = f158(x);
x = f59(x);
x = f154(x);
x = f76(x);
x = f210(x);
x = f224(x);
x = f135(x);
x = f80(x);
x = f236(x);
x = f139(x);
x = f272(x);
x = f259(x);
x = f90(x);
x = f64(x);
x = f138(x);
x = f198(x);
x = f191(x);
x = f63(x);
x = f253(x);
x = f152(x);
x = f286(x);
x = f282(x);
x = f38(x);
x = f182(x);
x = f8(x);
x = f50(x);
x = f192(x);
x = f4(x);
x = f241(x);
x = f124(x);
x = f251(x);
x = f142(x);
x = f123(x);
x = f60(x);
x = f264(x);
x = f87(x);
x = f44(x);
x = f145(x);
x = f261(x);
x = f2(x);
x = f221(x);
x = f30(x);
x = f248(x);
x = f243(x);
x = f92(x);
x = f246(x);
x = f7(x);
x = f172(x);
x = f27(x);
x = f53(x);
x = f266(x);
x = f214(x);
x = f79(x);
x = f67(x);
x = f106(x);
x = f127(x);
x = f277(x);
x = f136(x);
x = f185(x);
x = f153(x);
x = f107(x);
x = f58(x);
x = f177(x);
x = f137(x);
x = f161(x);
x = f208(x);
x = f239(x);
x = f88(x);
x = f83(x);
x = f284(x);
x = f11(x);
x = f163(x);
x = f233(x);
x = f103(x);
x = f165(x);
x = f211(x);
x = f89(x);
x = f188(x);
x = f28(x);
x = f267(x);
x = f1(x);
x = f104(x);
x = f155(x);
x = f265(x);
x = f36(x);
x = f132(x);
x = f240(x);
x = f84(x);
x = f39(x);
x = f195(x);
x = f279(x);
x = f179(x);
x = f289(x);
x = f143(x);
x = f147(x);
x = f180(x);
x = f110(x);
x = f49(x);
x = f86(x);
x = f151(x);
x = f37(x);
x = f73(x);
x = f42(x);
x = f26(x);
x = f85(x);
x = f226(x);
x = f258(x);
x = f101(x);
x = f206(x);
x = f202(x);
x = f21(x);
x = f148(x);
x = f262(x);
x = f164(x);
x = f100(x);
x = f278(x);
x = f18(x);
x = f181(x);
x = f171(x);
x = f111(x);
x = f12(x);
x = f81(x);
x = f263(x);
x = f82(x);
x = f51(x);
x = f230(x);
x = f204(x);
x = f219(x);
x = f117(x);
x = f176(x);
x = f24(x);
x = f160(x);
x = f189(x);
x = f140(x);
x = f96(x);
x = f45(x);
x = f238(x);
return x;}
__attribute__((noinline)) unsigned order3(unsigned x){
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
x = f0(x);
x = f0(x);
x = f1(x);
x = f0(x);
x = f64(x);
x = f65(x);
x = f255(x);
x = f256(x);
x = f16(x);
x = f63(x);
x = f128(x);
x = f0(x);
return x;}
int main(void){unsigned h=1;for(unsigned i=0;i<100;i++)h=(h*33u+order0(i))^(order1(i)+order2(i)+order3(i)+indirect(no_calls,i)+replaceable(i));printf("%u\n",h);return 0;}
