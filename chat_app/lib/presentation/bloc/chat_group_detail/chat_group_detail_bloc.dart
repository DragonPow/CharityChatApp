import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_group_detail_event.dart';
part 'chat_group_detail_state.dart';

class ChatGroupDetailBloc extends Bloc<ChatGroupDetailEvent, ChatGroupDetailState> {
  ChatGroupDetailBloc() : super(ChatGroupDetailInitial()) {
    on<ChatGroupDetailEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
