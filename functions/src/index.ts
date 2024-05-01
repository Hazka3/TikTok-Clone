// import { onRequest } from "firebase-functions/v2/https";
// import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

export const onVideoCreated = functions.firestore
  .document("/videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const spawn = require("child-process-promise").spawn;
    const video = snapshot.data(); //snapshot => ここで生成したdocument
    await spawn("ffmpeg", [
      //npm > child-process-promissを使ってffmpegを実行
      //ffmpeg のコマンド（-iや-ssなど）は適宜検索してみる

      "-i", //input 命令
      video.fileUrl, //inputするlocation (url)、video_modelの"fileUrl" parameter を参照
      "-ss", //切り出しの開始位置に移動
      "00:00:01.000", //開始位置 = 再生1秒〜
      "-vframes", //静止画を切り出し
      "1", //切り出したい静止画の枚数
      "-vf", //ビデオフィルターを設定
      "scale=150:-1", //フィルター＞スケールを設定（容量削減＋リサイズのため）　縦:横、-1ならもう片方の値合わせて自動で調整される
      `/tmp/${snapshot.id}.jpg`,
      //一時保存ストレージにファイル名を指定して保存
      //cloud functionで生成されたファイルはtmpフォルダーに一時保存され、関数の実行が完了すると消去される。なので、リアルタイムで参照するstateは入れないこと
    ]);
    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      //storageにアップロードするファイルを指定　（ここでは一時保存storageから持ってきている）
      destination: `thumbnails/${snapshot.id}.jpg`, //storage/thumbnails/{snapshot.id}.jpg としてファイルを保存
    });
    await file.makePublic();
    await snapshot.ref.update({ thumbnailUrl: file.publicUrl() });

    const db = admin.firestore();
    await db
      .collection("users")
      .doc(video.creatorUid)
      .collection("videos")
      .doc(snapshot.id)
      .set({ thumbnailUrl: file.publicUrl(), videoId: snapshot.id });
  });

export const onLikedCreated = functions.firestore
  .document("likes/{likeId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, userId] = snapshot.id.split("000");
    const videoRef = db.collection("videos").doc(videoId);
    videoRef.get().then(async (doc) => {
      if (doc.exists) {
        const thumbnailUrl = doc.data()!.thumbnailUrl;
        await db
          .collection("users")
          .doc(userId)
          .collection("likes")
          .doc(videoId)
          .set({ thumbnailUrl: thumbnailUrl, videoId: videoId });
      } else {
        return;
      }
    });
    await db
      .collection("videos")
      .doc(videoId)
      .update({ likes: admin.firestore.FieldValue.increment(1) });
  });

export const onLikedRemoved = functions.firestore
  .document("likes/{likeId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, userId] = snapshot.id.split("000");
    await db
      .collection("users")
      .doc(userId)
      .collection("likes")
      .doc(videoId)
      .delete();
    await db
      .collection("videos")
      .doc(videoId)
      .update({ likes: admin.firestore.FieldValue.increment(-1) });
  });
