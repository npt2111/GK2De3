import { Share } from '@capacitor/share';
import { LocalNotifications } from '@capacitor/local-notifications';

window.addEventListener('flutterInAppWebViewPlatformReady', function() {
    window.flutter_inappwebview.callHandler('capacitor_bridge', (args) => {
        if (args.method === 'share') {
            return Share.share({
                title: 'Sinh nhật của tôi',
                text: args.message,
                dialogTitle: 'Chia sẻ thông tin'
            });
        } else if (args.method === 'notify') {
            return LocalNotifications.schedule({
                notifications: [{
                    title: args.title,
                    body: args.body,
                    id: 1,
                    schedule: { at: new Date(new Date().getTime() + 5000) } // 5 giây sau
                }]
            });
        }
    });
});

