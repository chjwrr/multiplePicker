/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    Platform,
    StyleSheet,
    Text,
    View,
    TouchableOpacity,

    NativeModules,
    NativeAppEventEmitter
} from 'react-native';

const MultiplePicker = NativeModules.MultiplePickBridgeModule;

export default class App extends Component<{}> {

    constructor(props){
        super(props);
    }

    componentDidMount() {
        MultiplePicker.init({

            // 必填

            // 省市区 == PCA
            // 年月日 == YMD
            // 时分秒 == HM
            // 年月日时分 == YMDHM
            // 自定义多级不联动 == CUSTOM
            // 自定义多级联动 == CUSTOMLINKAGE
            pickerType: 'CUSTOMLINKAGE',

            // 常规设置 可选
            centerType: 'both', // line  color   both
            centerColor: '#f5f5f5',
            topViewBgColor: '#f5f5f5',
            leftTitleColor: '#8F8F8F',
            rightTitleColor: '#4876FF',
            centerTitleColor: '#000000',
            leftTitle: '取消',
            rightTitle: '确定',
            centerTitle: '选择',

            // 年月日 设置 可选 默认：yyyy-MM-dd
            ymdTimeFormatter: 'yyyy-MM-dd',

            // 时分  设置 可选 默认：HH:mm
            hmTimeFormatter: 'HH:mm',

            // 年月日时分  设置 可选 默认：yyyy-MM-dd HH:mm
            ymdhmTimeFormatter: 'yyyy-MM-dd HH:mm',

            // 自定义多级不联动 必填
            customData: [
                [
                    {id: 1, title: '战争女神', price: '1'},
                    {id: 2, title: '战争之王', price: '2'},
                    {id: 3, title: '琴瑟仙女', price: '3'},
                    {id: 4, title: '探险家', price: '4'},
                    {id: 5, title: '迅捷斥候', price: '5'},
                    {id: 6, title: '德玛西亚皇子', price: '6'},
                    {id: 7, title: '刀锋意志', price: '7'},
                ],
                [
                    {id: 8, title: '水银之靴', price: '8'},
                    {id: 9, title: '黑色切割者', price: '9'},
                    {id: 10, title: '振奋盔甲', price: '10'},
                    {id: 11, title: '荆棘之甲', price: '11'},
                    {id: 12, title: '日炎斗篷', price: '12'},
                ],
                [
                    {id: 13, title: '致命打击', price: '13'},
                    {id: 14, title: '勇气', price: '14'},
                    {id: 15, title: '裁决', price: '15'},
                    {id: 16, title: '德玛西亚正义', price: '16'},

                ],
                [
                    {id: 17, title: '蒙多', price: '17'},
                    {id: 18, title: '茂凯', price: '18'},
                    {id: 19, title: '潘森', price: '19'},
                    {id: 20, title: '伊泽瑞尔', price: '20'},
                    {id: 21, title: '提莫', price: '21'},
                    {id: 22, title: '嘉文四世', price: '22'},
                    {id: 23, title: '李青', price: '23'},
                    {id: 24, title: '盖伦', price: '24'},
                    {id: 25, title: '莫甘娜', price: '25'},
                    {id: 26, title: '安妮', price: '26'},
                    {id: 27, title: '赵信', price: '127'},
                ],
            ],

            // 自定义多级联动 必填
            customLinkageData: [
                {
                    id: '1',
                    title: '植物',
                    subs:[
                        {
                            id: '2',
                            title: '树木',
                            subs: [
                                {
                                    id: '3',
                                    title: '乔木',
                                },
                                {
                                    id: '7',
                                    title: '灌木'
                                },
                            ]
                        },
                    ]
                },
                {
                    id: '13',
                    title: '动物',
                    subs:[
                        {
                            id: '14',
                            title: '海洋',
                            subs: [
                                {
                                    id: '15',
                                    title: '鲸鱼',
                                },
                                {
                                    id: '16',
                                    title: '鲨鱼'
                                },
                                {
                                    id: '17',
                                    title: '海豚'
                                },
                                {
                                    id: '18',
                                    title: '水母'
                                },
                                {
                                    id: '19',
                                    title: '海马'
                                },
                                {
                                    id: '20',
                                    title: '海狮'
                                },
                            ]
                        },
                        {
                            id: '21',
                            title: '陆地',
                            subs: [
                                {
                                    id: '22',
                                    title: '狮子',
                                },
                                {
                                    id: '23',
                                    title: '猴子'
                                },
                                {
                                    id: '24',
                                    title: '猎豹'
                                },
                                {
                                    id: '25',
                                    title: '大象'
                                }
                            ]
                        },
                        {
                            id: '26',
                            title: '天空',
                            subs: [
                                {
                                    id: '27',
                                    title: '秃鹫',
                                },
                                {
                                    id: '28',
                                    title: '雕'
                                },
                                {
                                    id: '29',
                                    title: '鹰'
                                },
                                {
                                    id: '30',
                                    title: '燕子'
                                },
                                {
                                    id: '31',
                                    title: '鸽子'
                                }
                            ]
                        },
                    ]
                },
                {
                    id: '32',
                    title: '微生物',
                    subs:[
                        {
                            id: '33',
                            title: '原核',
                            subs: [
                                {
                                    id: '34',
                                    title: '细菌',
                                },
                                {
                                    id: '35',
                                    title: '放线菌'
                                },
                                {
                                    id: '36',
                                    title: '螺旋体'
                                },
                                {
                                    id: '37',
                                    title: '支原体'
                                },
                                {
                                    id: '38',
                                    title: '立克次氏体'
                                },
                                {
                                    id: '39',
                                    title: '衣原体'
                                },
                            ]
                        },
                        {
                            id: '40',
                            title: '真核',
                            subs: [
                                {
                                    id: '41',
                                    title: '真菌',
                                },
                                {
                                    id: '42',
                                    title: '藻类'
                                },
                                {
                                    id: '43',
                                    title: '原生动物'
                                }
                            ]
                        },
                        {
                            id: '44',
                            title: '非细胞类',
                            subs: [
                                {
                                    id: '45',
                                    title: '病毒',
                                },
                                {
                                    id: '51',
                                    title: '亚病毒',
                                }
                            ]
                        },
                    ]
                },
            ]
        });

    }
   
    render() {
        return (

            <View style={styles.container}>

                <TouchableOpacity
                    style={{marginTop: 64, padding: 10, backgroundColor: 'red', justifyContent: 'center', alignItems: 'center'}}
                    onPress={()=>{

                        MultiplePicker.showPCAPicker().then((data)=>{
                            console.log('data===',data)
                        });

                        MultiplePicker.showTimePicker().then((time)=>{
                            console.log('time===',time)
                        });

                        MultiplePicker.showCustomPicker().then((data)=>{
                            console.log('customData===',data)
                        });
                    }}
                >
                    <Text style={styles.welcome}>
                        点击弹出picker
                    </Text>
                </TouchableOpacity>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F5FCFF',
    }
});
